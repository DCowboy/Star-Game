
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
##            if stats[stat] < 2:
##                slots += 0
##            elif stats[stat] < 4:
##                slots += 1
##            elif stats[stat] < 5:
##                slots += 2
##            else:
##                slots += 3
            slots += round(stats[stat] / 1.7 -.5, 0)
        elif size == 'medium':
##            if stats[stat] < 5:
##                slots += 0
##            elif stats[stat] < 6:
##                slots += 1
##            elif stats[stat] < 8:
##                slots += 2
##            elif stats[stat] < 9:
##                slots += 3
##            else:
##                slots += 4
            slots += round(stats[stat] / 2.5 -.5, 0)
        elif size == 'large':
##            if stats[stat] < 9:
##                slots += 2
##            elif stats[stat] < 11:
##                slots += 3
##            elif stats[stat] < 14:
##                slots += 4
##            else:
##                slots += 5
            slots += round(stats[stat] / 3 -.5, 0)
        
            

        upgrades[stat] = slots  
        total += upgrades[stat]
    
    upgrades['total'] = total
    return upgrades

def set_equip_slots(size, variation, stats, race):
    equips = {'offensive': {'slots': 0, 'draw': 0},
              'defensive': {'slots': 0, 'draw': 0},
              'navigation': {'slots': 0, 'draw': 0},
              'sys_maint': {'slots': 0, 'draw': 0},
              'ship_maint': {'slots': 0, 'draw': 0},
              'supply': {'slots': 0, 'draw': 0}}
    main = None
    secondary = None

    total = 0
    for equip in sorted(equips):
        slots = equips[equip]['slots'] * 1.0
        base = None

        if size == 'large':# and  slots > 0:
            slots += .5
        elif size == 'small':# and slots < 3:
            slots -= .5
            
        if equip == 'offensive':
            base = 'tactical'
            main = stats[base]
            secondary = stats['engineering']
            if variation == 'combat':
                slots += 1
            elif variation == 'scout':
                slots += .5
                
        elif equip == 'defensive':
            base = 'tactical'
            main = stats[base]
            secondary = stats['operations']
            if variation == 'combat':
                slots += 1
            elif variation == 'supply':
                slots += .5

                
        elif equip == 'navigation':
            base = 'engineering'
            main = stats[base]
            secondary = stats['operations']
            if variation == 'scout':
                slots += 1
            elif variation == 'combat':
                slots += .5
                
        elif equip == 'sys_maint':
            base = 'engineering'
            main = stats[base]
            secondary = stats['tactical']
            if variation == 'scout':
                slots += 1
            elif variation == 'supply':
                slots += .5
                
        elif equip == 'supply':
            base = 'operations'
            main = stats[base]
            secondary = stats['engineering']
            if variation == 'supply':
                slots += 1
            elif variation == 'scout':
                slots += .5
                
        elif equip == 'ship_maint':
            base = 'operations'
            main = stats[base]
            secondary = stats['tactical']
            if variation == 'supply':
                slots += 1
            elif variation == 'combat':
                slots += .5
                
        if base == 'tactical':
            if race == 'Chentia':# and slots < 4:
                slots += 1
            elif race == 'Urthrax' and slots % 1 != 0:
                slots += .5
        elif base == 'operations':
            if race == 'Urthrax':# and slots < 4:
                slots += 1
            elif race == 'Terran' and slots % 1 != 0:
                slots += .5
        elif base == 'engineering':
            if race == 'Terran':# and slots < 4:
                slots += 1
            elif race == 'Chentia' and slots % 1 != 0:
                slots += .5

        if secondary == stats['tactical'] and slots % 1 != 0:
            slots += .5
        elif secondary == stats['operations'] and slots % 1 != 0:
            slots += .5
        elif secondary == stats['engineering'] and slots % 1 != 0:
            slots += .5        


        draw = round((main * 2 / 3) + (secondary / 3))
        equips[equip]['draw'] = draw #round(check / 3)
        equips[equip]['slots'] = int(slots)
        total += equips[equip]['slots']

    equips['total'] = total
    equips['formula'] = 'round((main * 2 / 3) + (secondary / 3))'#'round((main + (2*secondary/3) + (tertiary/3)) / 3)'
    return equips


def build_ships():
    for size in sorted(sizes):

        for race in sorted(races):

            for variation in sorted(variations):
                kind = size + race + variation
                stats = set_stats(size, race, variation)
                upgrades = set_upgrade_slots(size, stats)
                equips = set_equip_slots(size, variation, stats, race)
                data = {'size': size, 'race': race, 'variation': variation,
                        'stats': stats, 'upgrade_slots': upgrades,
                        'equip_slots': equips}

                ships[kind] = data


def print_stats():
    print('BASE STATS')
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
    print('UPGRADE SLOTS')
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
    print('EQUIPMENT SLOTS')
    print('| ship                   |type | off | def | nav | sym | shm | sup | tot |')
    for ship in sorted(ships):
        name = ships[ship]['size'] + ' ' + ships[ship]['race'] + ' ' + ships[ship]['variation']          
        ofnv = ships[ship]['equip_slots']['offensive']['slots']
        odrw = ships[ship]['equip_slots']['offensive']['draw']
        dfnv = ships[ship]['equip_slots']['defensive']['slots']
        ddrw = ships[ship]['equip_slots']['defensive']['draw']
        navi = ships[ship]['equip_slots']['navigation']['slots']
        ndrw = ships[ship]['equip_slots']['navigation']['draw']
        sysm = ships[ship]['equip_slots']['sys_maint']['slots']
        ydrw = ships[ship]['equip_slots']['sys_maint']['draw']
        shpm = ships[ship]['equip_slots']['ship_maint']['slots']
        hdrw = ships[ship]['equip_slots']['ship_maint']['draw']
        supp = ships[ship]['equip_slots']['supply']['slots']
        sdrw = ships[ship]['equip_slots']['supply']['draw']
        tots = ships[ship]['equip_slots']['total']
        dtot = round(odrw + ddrw + ndrw + ydrw + hdrw + sdrw)

        print('|------------------------|-----|-----|-----|-----|-----|-----|-----|-----|')
        print('| {0:22} |slots| {1:3} | {2:3} | {3:3} | {4:3} | {5:3} | {6:3} | {7:3} |'.format(name, ofnv, dfnv, navi, sysm, shpm, supp, tots))
##        print('|                        |draws| {0:3} | {1:3} | {2:3} | {3:3} | {4:3} | {5:3} | {6:3} |'.format(odrw, ddrw, ndrw, ydrw, hdrw, sdrw, dtot))

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
    
        

main()
        
    
