

sizes = {'small': {'base': 3,
                   'vessel+': 1, 'vessel-': -0,
                   'race+': 1, 'race-': -1},
         'medium': {'base': 5,
                    'vessel+': 2, 'vessel-': -1,
                    'race+': 2, 'race-': -0},
         'large': {'base': 8,
                   'vessel+': 3, 'vessel-': -2,
                   'race+': 3, 'race-': 1}}

variations = {'defensive': {'tactical': '=', 'core': '+', 'engineering': '-'},
              'supply': {'tactical': '-', 'core': '=', 'engineering': '+'},
              'assault': {'tactical': '+', 'core': '-', 'engineering': '='}}

races = {'Chentia': {'tactical': '+', 'core': '=', 'engineering': '-'},
         'Urthrax': {'tactical': '-', 'core': '+', 'engineering': '='},
         'Terran': {'tactical': '=', 'core': '-', 'engineering': '+'}}

def stat_mod(size, race, variation):
    stats = {'tactical': sizes[size]['base'],
             'core': sizes[size]['base'],
             'engineering': sizes[size]['base']}
    print(' ')
    print('stats: ' + size + ' ' + race + ' ' + variation)
    for stat, value in stats.items():
        print(stat + ' old value: ' + str(value))
        if variations[variation][stat] == '+':
            stats[stat] += sizes[size]['vessel+']
        elif variations[variation][stat] == '-':
            stats[stat] += sizes[size]['vessel-']
           
        if races[race][stat] == '+':
            stats[stat] += sizes[size]['race+']
        elif races[race][stat] == '-':
            stats[stat] += sizes[size]['race-']
        print(stat + ' new value: ' + str(stats[stat]))
        
        
    return stats

def get_upgrade_slots(size, stats):
    upgrades = {}
    total = 0
    for stat, value in stats.items():
        if size == 'small':
            if stats[stat] <= 2:
                upgrades[stat] = 0
            elif stats[stat] <= 3:
                upgrades[stat] = 1
                total += 1
            elif stats[stat] <= 5:
                upgrades[stat] = 2
                total += 2
            else:
                upgrades[stat] = 3
                total += 3
        elif size == 'medium':
            if stats[stat] <= 1:
                upgrades[stat] = 0
            elif stats[stat] <= 3:
                upgrades[stat] = 1
                total += 1
            elif stats[stat] <= 4:
                upgrades[stat] = 2
                total += 2
            elif stats[stat] <=6:
                upgrades[stat] = 3
                total += 3
            else:
                upgrades[stat] = 4
                total += 4
        elif size == 'large':
            if stats[stat] <= 3:
                upgrades[stat] = 2
                total += 2
            elif stats[stat] <= 7:
                upgrades[stat] = 3
                total += 3
            elif stats[stat] <= 9:
                upgrades[stat] = 4
                total += 4
            else:
                upgrades[stat] = 5
                total += 5
    upgrades['total'] = total
    return upgrades

def get_equip_slots(sz, var, stats):
    equips = {'weapons': 0, 'defense': 0, 'supply': 0}
    main = None
    secondary = None
    tertiary = None
    total = 0
    for equip, value in equips.items():
        if equip == 'weapons':
            main = stats['tactical']
            secondary = stats['engineering']
            tertiary = stats['core']
        elif equip == 'defense':
            main = stats['core']
            secondary = stats['tactical']
            tertiary = stats['engineering']
        elif equip == 'supply':
            main = stats['engineering']
            secondary = stats['core']
            tertiary = stats['tactical']
        check1 = int((main + (2*secondary/3) + (tertiary/3)) / 3)
        check2 = round((main + (2*secondary/3) + (tertiary/3)))
        check3 = round(main + (secondary/2) + (tertiary/4))
        check4 = main + secondary
        print(str(check1) + ' -> ' + str(check2) + ' -> ' + str(check3) + ' -> ' + str(check4))
        
         
        slots = '' #int(((main) + ( (3-size) * secondary / (3)) + (size * tertiary / (3))) / 2)
        if sz == 'small':
            slots = int((main + secondary) / 2)
        elif sz == 'medium':
            slots = int((main + secondary) / 3)
        elif sz == 'large':
            slots = int((main + secondary) / 5)
        print('equip_slot: ' + equip + ' ' + str(slots) + '| main: ' + str(main)
              + ' secondary: ' + str(secondary) + ' tertiary: ' +str(tertiary))
        equips[equip] = slots
        total += slots
    equips['total'] = total
    return equips


def print_stats():

    pass
    

def print_upgrades():

    pass


def print_equipment():

    pass


def print_totals():

    pass


def main():
    ships = {}
    for size, value in sizes.items():
        sz = size
        for race, value in races.items():
            rce =race
            for variation, value in variations.items():
                var = variation
                stats = stat_mod(sz, rce, var)
                upgrades = get_upgrade_slots(sz, stats)
                equips = get_equip_slots(sz, var, stats)
                kind = str(sz + rce + var)
                data = {'size': sz, 'race': rce, 'variation': var,
                        'stats': stats, 'upgrade_slots': upgrades,
                        'equip_slots': equips}
                
                ships[kind] = data

    print('ship     | tact | core | engg | tupg | cupg | eupg | utot | weap | defn | supp | etot | ttot')
    
    for ship in sorted(ships):
        name = ''
        if ships[ship]['size'] == 'small':
            name += 'S-'
        elif ships[ship]['size'] == 'medium':
            name += 'M-'
        elif ships[ship]['size'] == 'large':
            name += 'L-'       
        if ships[ship]['race'] == 'Chentia':
            name += 'C-'
        elif ships[ship]['race'] == 'Urthrax':
            name += 'U-'
        elif ships[ship]['race'] == 'Terran':
            name += 'T-'
        if ships[ship]['variation'] == 'defensive':
            name += 'defv'
        elif ships[ship]['variation'] == 'supply':
            name += 'supp'
        elif ships[ship]['variation'] == 'assault':
            name += 'aslt'            
        tact = ships[ship]['stats']['tactical']
        tupg = ships[ship]['upgrade_slots']['tactical']
        core = ships[ship]['stats']['core']
        cupg = ships[ship]['upgrade_slots']['core']
        engg = ships[ship]['stats']['engineering']
        eupg = ships[ship]['upgrade_slots']['engineering']
        utot = ships[ship]['upgrade_slots']['total']
        weap = ships[ship]['equip_slots']['weapons']
        defn = ships[ship]['equip_slots']['defense']
        supp = ships[ship]['equip_slots']['supply']
        etot = ships[ship]['equip_slots']['total']
        ttot = utot + etot
        print('---------+------+------+------+------+------+------+------+------+------+------+------+-----')
        print('{0:1} | {1:4} | {2:4} | {3:4} | {4:4} | {5:4} | {6:4} | {7:4} | {8:4} | {9:4} | {10:4} | {11:4} | {12:4}'.format(name, tact, core, engg, tupg, cupg,
                                            eupg, utot, weap, defn, supp, etot,
                                            ttot))

        

main()
        
    
