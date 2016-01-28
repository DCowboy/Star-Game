
ships = {}
sizes = {'small': {'base_stat': 3, 
                   'vessel+': 1, 'vessel-': -0,
                   'race+': 1, 'race-': -2},
         'medium': {'base_stat': 6, 
                    'vessel+': 2, 'vessel-': -1,
                    'race+': 2, 'race-': -1},
         'large': {'base_stat': 9,
                   'vessel+': 3, 'vessel-': -2,
                   'race+': 3, 'race-': 0}}

variations = {'combat': {'tactical': '+', 'operations': '=', 'engineering': '-'},
              'supply': {'tactical': '-', 'operations': '+', 'engineering': '='},
              'scout': {'tactical': '=', 'operations': '-', 'engineering': '+'}}

races = {'Chentia': {'tactical': '+', 'operations': '-', 'engineering': '='},
         'Urthrax': {'tactical': '=', 'operations': '+', 'engineering': '-'},
         'Terran': {'tactical': '-', 'operations': '=', 'engineering': '+'}}

def set_stats(size, race, variation):
    stats = {'tactical': sizes[size]['base_stat'],
             'operations': sizes[size]['base_stat'],
             'engineering': sizes[size]['base_stat']}
    total = 0
#    print(' ')
#    print('stats: ' + size + ' ' + race + ' ' + variation)
    for stat in sorted(stats):
#        print(stat + ' old value: ' + str(stats[stat]))
        if variations[variation][stat] == '+':
            stats[stat] += sizes[size]['vessel+']
        elif variations[variation][stat] == '-':
            stats[stat] += sizes[size]['vessel-']
           
        if races[race][stat] == '+':
            stats[stat] += sizes[size]['race+']
        elif races[race][stat] == '-':
            stats[stat] += sizes[size]['race-']
        
        total += stats[stat]
#        print(stat + ' new value: ' + str(stats[stat]))
        
    stats['total'] = total   
    return stats

def set_upgrade_slots(size, stats):
    upgrades = {'tactical': 0,
                'operations': 0,
                'engineering': 0}
    total = 0

        
    for stat in sorted(upgrades):
        slots = upgrades[stat]
        if size == 'small':
            if stats[stat] < 2:
                slots += 0
            elif stats[stat] < 4:
                slots += 1
            elif stats[stat] < 5:
                slots += 2
            else:
                slots += 3
        elif size == 'medium':
            if stats[stat] < 5:
                slots += 0
            elif stats[stat] < 6:
                slots += 1
            elif stats[stat] < 8:
                slots += 2
            elif stats[stat] < 9:
                slots += 3
            else:
                slots += 4
        elif size == 'large':
            if stats[stat] < 9:
                slots += 2
            elif stats[stat] < 11:
                slots += 3
            elif stats[stat] < 14:
                slots += 4
            else:
                slots += 5

            

        upgrades[stat] = slots  
        total += upgrades[stat]
    
    upgrades['total'] = total
    return upgrades

def set_equip_slots(size, variation, stats):
    equips = {'armaments': {'slots': 3, 'draw': 0},
              'navigation': {'slots': 3, 'draw': 0},
              'supply': {'slots': 3, 'draw': 0}}
    main = None
    secondary = None
    tertiary = None
    total = 0
    for equip in sorted(equips):
        slots = equips[equip]['slots']
        base = None
        limits =(2, 4)
        if size == 'small':
            slots -= 1

        elif size == 'large':
            slots += 1
            
        if equip == 'armaments':
            base = 'tactical'
            main = stats[base]
            secondary = stats['operations']
            tertiary = stats['engineering']
            if variation == 'combat':
                slots += 1
            elif variation == 'supply':
                slots -= 1
                
        elif equip == 'navigation':
            base = 'engineering'
            main = stats[base]
            secondary = stats['tactical']
            tertiary = stats['operations']
            if variation == 'combat':
                slots -= 1
            elif variation == 'scout':
                slots += 1
                
        elif equip == 'supply':
            base = 'operations'
            main = stats[base]
            secondary = stats['engineering']
            tertiary = stats['tactical']
            if variation == 'supply':
                slots += 1
            elif variation == 'scout':
                slots -= 1

        check = round((main + (2*secondary/3) + (tertiary/3)))
##        check2 = round(main + (secondary/2) + (tertiary/4))
        equips[equip]['draw'] = round(check / 3)
        equips[equip]['slots'] = round(slots)
        total += equips[equip]['slots']

    equips['total'] = total
    equips['formula'] = 'round((main + (2*secondary/3) + (tertiary/3)) / 3)'
    return equips


def build_ships():
    for size in sorted(sizes):

        for race in sorted(races):

            for variation in sorted(variations):
                kind = size + race + variation
                stats = set_stats(size, race, variation)
                upgrades = set_upgrade_slots(size, stats)
                equips = set_equip_slots(size, variation, stats)
                data = {'size': size, 'race': race, 'variation': variation,
                        'stats': stats, 'upgrade_slots': upgrades,
                        'equip_slots': equips}

                ships[kind] = data


def print_stats():
    print('STATS')
    print('| ship                   | tac | ops | eng | tot |')
    for ship in sorted(ships):
        name = ships[ship]['size'] + ' ' + ships[ship]['race'] + ' ' + ships[ship]['variation']          
        tact = ships[ship]['stats']['tactical']
        core = ships[ship]['stats']['operations']
        engg = ships[ship]['stats']['engineering']
        tots = ships[ship]['stats']['total']

        print('|------------------------|-----+-----+-----|-----|')
        print('| {0:22} | {1:3} | {2:3} | {3:3} | {4:3} |'.format(name, tact, core, engg, tots))
    

def print_upgrades():
    print('UPGRADES')
    print('| ship                   | tac | ops | eng | tot |')
    for ship in sorted(ships):
        name = ships[ship]['size'] + ' ' + ships[ship]['race'] + ' ' + ships[ship]['variation']          
        tact = ships[ship]['upgrade_slots']['tactical']
        core = ships[ship]['upgrade_slots']['operations']
        engg = ships[ship]['upgrade_slots']['engineering']
        tots = ships[ship]['upgrade_slots']['total']

        print('|------------------------|-----+-----+-----|-----|')
        print('| {0:22} | {1:3} | {2:3} | {3:3} | {4:3} |'.format(name, tact, core, engg, tots))

    pass


def print_equipment():
    print('EQUIPMENT')
    print('| ship                   | arm + drw | nav + drw | sup + drw | tot + drt |')
    for ship in sorted(ships):
        name = ships[ship]['size'] + ' ' + ships[ship]['race'] + ' ' + ships[ship]['variation']          
        arms = ships[ship]['equip_slots']['armaments']['slots']
        adrw = ships[ship]['equip_slots']['armaments']['draw']
        defn = ships[ship]['equip_slots']['navigation']['slots']
        ddrw = ships[ship]['equip_slots']['navigation']['draw']
        supp = ships[ship]['equip_slots']['supply']['slots']
        sdrw = ships[ship]['equip_slots']['supply']['draw']
        tots = ships[ship]['equip_slots']['total']
        dtot = adrw + ddrw + sdrw

        print('|------------------------|-----+-----|-----+-----|-----+-----|-----+-----|')
        print('| {0:22} | {1:3} | {2:3} | {3:3} | {4:3} | {5:3} | {6:3} | {7:3} | {8:3} |'.format(name, arms, adrw, defn, ddrw, supp, sdrw, tots, dtot))

    print('draw formula: ' + str(ships[ship]['equip_slots']['formula']))
    pass


def print_totals():
    print('TOTALS')
    print('| ship                   | stt | upt | eqt | uet |')
    for ship in sorted(ships):
        name = ships[ship]['size'] + ' ' + ships[ship]['race'] + ' ' + ships[ship]['variation']          
        stot = ships[ship]['stats']['total']
        utot = ships[ship]['upgrade_slots']['total']
        etot = ships[ship]['equip_slots']['total']
        tots = utot + etot

        print('|------------------------|-----|-----+-----|-----|')
        print('| {0:22} | {1:3} | {2:3} | {3:3} | {4:3} |'.format(name, stot, utot, etot, tots))

    pass


def main():
    build_ships()
    print_stats()
    print('')
    print_upgrades()
    print('')
    print_equipment()
    print('')
    print_totals()
    
##    print('| ship    | tac | ops | eng | tup | oup | eup | utt | arm | nav | sup | ett | tot |')
##    
##    for ship in sorted(ships):
##        name = ''
##        if ships[ship]['size'] == 'small':
##            name += 'S-'
##        elif ships[ship]['size'] == 'medium':
##            name += 'M-'
##        elif ships[ship]['size'] == 'large':
##            name += 'L-'       
##        if ships[ship]['race'] == 'Chentia':
##            name += 'C-'
##        elif ships[ship]['race'] == 'Urthrax':
##            name += 'U-'
##        elif ships[ship]['race'] == 'Terran':
##            name += 'T-'
##        if ships[ship]['variation'] == 'combat':
##            name += 'cbt'
##        elif ships[ship]['variation'] == 'supply':
##            name += 'sup'
##        elif ships[ship]['variation'] == 'scout':
##            name += 'sct'            
##        tact = ships[ship]['stats']['tactical']
##        tupg = ships[ship]['upgrade_slots']['tactical']
##        core = ships[ship]['stats']['operations']
##        cupg = ships[ship]['upgrade_slots']['operations']
##        engg = ships[ship]['stats']['engineering']
##        eupg = ships[ship]['upgrade_slots']['engineering']
##        utot = ships[ship]['upgrade_slots']['total']
##        arms = ships[ship]['equip_slots']['armaments']['slots']
##        defn = ships[ship]['equip_slots']['navigation']['slots']
##        supp = ships[ship]['equip_slots']['supply']['slots']
##        etot = ships[ship]['equip_slots']['total']
##        ttot = utot + etot
##        print('|---------|-----+-----+-----|-----+-----+-----|-----|-----+-----+-----|-----|-----|')
##        print('| {0:1} | {1:3} | {2:3} | {3:3} | {4:3} | {5:3} | {6:3} | {7:3} | {8:3} | {9:3} | {10:3} | {11:3} | {12:3} |'.format(name, tact, core, engg, tupg, cupg,
##                                            eupg, utot, arms, defn, supp, etot,
##                                            ttot))

        

main()
        
    
