def welcome
  puts "
  █     █          █ █
  █     █   █ █ █    █     █ █ █    █ █ █   █ █   █ █   █ █ █
  █     █  █     █   █    █        █     █  █  █ █  █  █     █
  █  █  █  █ █ █ █   █    █        █     █  █   █   █  █ █ █ █
  █ █ █ █  █         █    █        █     █  █   █   █  █
   █   █    █ █ █    █ █   █ █ █    █ █ █   █   █   █   █ █ █

                                    /\\   /\\
    █                              / /\\_/\\ \\
    █      █ █ █                   \\/ _ _ \\/       __________
  █ █ █   █     █                  |  o o  |      (,______ __)
    █     █     █                  |#     #|       \\\\  ( ) #|
    █     █     █                 / \\.   ./ \\       \\\\#  # ,|
     █ █   █ █ █                 /  >(. .)<  \\       \\\\#  (_|
                                 |    \\ /     \\       \\\\,#  |
    █     █                      |     0      |        \\\\ _#|
    █     █        █ █ █         / \\  ,     \\ \\        ,\\\\ )|
  █ █ █   █ █ █   █     █       |   \\ \\      \\ \\         \\\\ |
    █     █    █  █ █ █ █       |    \\mb      dm          \\\\|
    █     █    █  █            /                \\          ;
     █ █  █    █   █ █ █       \\     \\     /    /\\___________
                                \\__nnn\\___|nnn_/\\/_|_|_|_|_|,>

  █ █ █         █ █      █     █            █ █ █ █     █ █
  █     █     █     █    █     █                  █   █     █
  █      █   █       █   █ █ █ █                  █  █       █
  █      █   █       █   █     █    █ █ █         █  █       █
  █     █     █     █    █     █            █     █   █     █
  █ █ █   █     █ █   █  █     █  █           █ █       █ █
  "
end

def get_input
  input = gets.chomp
end

def user_name_prompt
  puts "Please enter your name to begin:"
  print "> "

  user_name = get_input
  if user_name == ""
    user_name_prompt
  end
  puts ""
  puts "Hello, #{user_name}!"
  user_name
end


def main_menu(user)                                # MAIN MENU START
  puts ""
  puts "Welcome to the D.O.H.-Jo"
  puts "[ #{user.name} ]"
  puts "************************"
  puts "      MAIN MENU"
  puts "************************"
  puts ""
  puts "Options:"
  puts ""
  puts "1. Search the Restaurant Database!"
  puts "2. View My Favorites List"
  puts "3. Feeling Lucky?"
  puts "4. Violation Code Lookup"
  puts "5. Exit the Program"
  print "> "

  option = get_input
  case option
  when "1"
    res = restaurant_prompt
    restaurant = Restaurant.find_by(name: res.upcase)
    if restaurant == nil
      restaurant = populate_db_from_json(res, user)
    end
    restaurant.profile

    restaurant_menu(user, restaurant)

  when "2"
    user.favorite_restaurants

  when "3"
    puts ""
    puts "Let's roll the dice!"
    puts "************************"
    user.yuck_my_yum


  when "4"
    vcode_menu(user)

  when "5"
    exit

  when "exit"
    exit

  else
    main_menu(user)

  end
end                                                # MAIN MENU END

def restaurant_prompt
  puts ""
  puts "Which restaurant would you like to check out?"
  print "> "

  restaurant = get_input
  if restaurant == ""
    restaurant_prompt
  end
  restaurant
end

def restaurant_menu(user, restaurant)              # RESTAURANT MENU START
  puts ""
  puts "Options:"
  puts "1. Add to Favorites"
  puts "2. View Favorites"
  puts "3. View Worst Violation"
  puts "4. Exit to Main Menu"
  puts "Please enter a number"
  print "> "

  option = get_input
  case option
  when "1"
    user.add_to_favorites(restaurant)

  when "2"
    puts ""
    puts "View Favorites"
    puts "**************"
    user.favorite_restaurants

  when "3"
    puts ""
    puts "View Worst Violation"
    puts "**************"
    restaurant.worst_violation
    puts ""
    puts "Press return to return to #{restaurant.name}'s profile"

    returner = get_input
    restaurant.profile
    restaurant_menu(user, restaurant) if returner


  when "4" || "exit"
    puts ""
    puts "Exit to main menu"
    puts "*****************"
    main_menu(user)

  else
    "Please enter a number from the menu"
    restaurant_menu(user, restaurant)

  end
end                                                # RESTAURANT MENU END

def favorite_menu(fav)                             # FAVORITE MENU START
  puts ""
  puts "Restaurant: #{fav.restaurant.name}"
  puts "Cuisine: #{fav.restaurant.cuisine}"
  puts "Latest Grade: [ #{fav.restaurant.latest_inspection.grade} ] on #{fav.restaurant.latest_inspection.date}"
  puts "My Rating: #{fav.my_rating}"
  puts ""
  puts "Options:"
  puts "1. Edit Rating"
  puts "2. Delete Favorite"
  puts "3. View Full Inspection History"
  puts "4. Back to Favorites Menu"
  puts "5. Exit to Main Menu"
  print "> "

  option = get_input
  if option == ""
    favorite_menu(fav)
  end
  case option

  when "1"
    puts ""
    puts "Enter a new rating number"
    print "> "

    new_rating = get_input
    case new_rating
    when /\d{1,2}/
      fav.update_attribute(:my_rating, new_rating)
      puts ""
      puts "Rating updated to #{fav.my_rating}"
      puts "*****************"
      puts "Press return to return to your favorites"
    # when /\D/
    #   puts ""
    #   puts "Please enter a number"
    #   puts "Press return to return to your favorites"
    else
      puts ""
      puts "Hmm. Try again."
      puts "Press return to return to your favorites"
    end

    returner = get_input
    fav.user.favorite_restaurants if returner

  when "2"
    puts ""
    puts "Are you sure? [ Y / N ]"
    print "> "

    sure = get_input
    if sure.upcase == "Y"
      fav.user.favorites.delete(fav.id)
      fav.user.reload
      puts "Favorite deleted"
      puts "****************"
      puts "Press return to return to the main menu"

      returner = get_input
      main_menu(fav.user) if returner
    else
      favorite_menu(fav)
    end

  when "3"
    puts ""
    puts fav.restaurant.inspection_history
    puts "*****************"
    puts "Press return to return to favorites menu"

    returner = get_input
    favorite_menu(fav) if returner

  when "4"
    fav.user(favorite_restaurants)

  when "5"
    main_menu(fav.user)

  else
    puts "Please enter a number from the menu"
    favorite_menu(fav)
  end
end                                                # FAVORITE MENU END

def vcode_menu(user)
  puts ""
  puts "Enter number of a violation category to view"
  puts "or \'exit\' to Exit to Main Menu"
  puts ""
  puts "Scored Violations:                Unscored Violations:"
  puts "1.  [99] General                  11. [99] General"
  puts "2.  [02] Food Safety              12. [15] Tobacco"
  puts "3.  [03] Sourcing / Handling      13. [16] Nutrition Info"
  puts "4.  [04] The Bad Ones             14. [18] Permitting"
  puts "5.  [05] Equipment                15. [20] Signage"
  puts "6.  [06] Sanitation               16. [22] Operations"
  puts "7.  [07] Obstruction"
  puts "8.  [08] Pest Control"
  puts "9.  [09] Food Procedure"
  puts "10. [10] Facilities"

  print "> "

  option = get_input
  case option
  when "exit"
    main_menu(user)

  when "1"
    puts ""
    puts "99B - GENERAL - Miscellaneous"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "2"
    puts ""
    puts "02A - Public Health Hazard - Meats/other potentially hazardous hot foods not heated to proper temperature"
    puts "02B - Public Health Hazard - Hot food not held at 140°F or above"
    puts "02C - Critical - Previously heated and cooled potentially hazardous hot food not reheated to 165°F for 15 seconds within 2 hours"
    puts "02D - Critical - Commercially processed potentially hazardous food not heated to 140°F within 2 hours"
    puts "02E - Critical - Whole frozen poultry or poultry breast, other than a single portion, cooked frozen or partially thawed"
    puts "02F - Critical - Meat, fish, or shellfish served raw or partially cooked"
    puts "02G - Public Health Hazard - Cold potentially hazardous food not held at 41°F or below"
    puts "                             Reduced oxygen packaged raw/cold foods not held at proper temperatures"
    puts "02H - Public Health Hazard - Potentially hazardous food not cooled by approved method"
    puts "02I - Critical - Potentially hazardous food not cooled to 41°F when prepared from ambient temperature ingredients within 4 hours"
    puts "02J - Public Health Hazard - Reduced oxygen packaged foods not properly cooled"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "3"
    puts ""
    puts "03A - Public Health Hazard - Food not from approved source"
    puts "                             Reduced oxygen packaging fish not frozen before processing"
    puts "                             Meat not from an approved source"
    puts "03B - Public Health Hazard - Shellfish not from an approved source"
    puts "                             Shellfish improperly tagged or labeled"
    puts "                             Shellfish required tags not retained at least 90 days"
    puts "                             Wholesale shellfish records not on premises"
    puts "03C - Public Health Hazard - Eggs cracked, dirty or unpasteurized; source of eggs not identified on container"
    puts "03D - Public Health Hazard - Food packages damaged; cans of food swollen, leaking and/or rusted"
    puts "03E - Public Health Hazard - Potable water not provided; inadequate"
    puts "                             Bottled water not from an approved source"
    puts "                             Cross-connection observed between potable and non- potable water"
    puts "                             Carbon dioxide gas lines unacceptable, improper materials used"
    puts "03F - Public Health Hazard - Unpasteurized milk and milk products"
    puts "03G - Critical - Fruits and vegetables not washed prior to serving"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "4"
    puts ""
    puts "04A - Critical - Food Protection Certificate not held by supervisor or manager of food operations"
    puts "04B - Public Health Hazard - Food worker with illness, communicable disease and/or injury preparing food"
    puts "04C - Public Health Hazard - Bare hand contact with ready-to-eat foods"
    puts "04D - Public Health Hazard - Food worker failed to wash hands after contamination"
    puts "04E - Public Health Hazard - Pesticides not properly stored/used; food, equipment, utensils, etc., not protected from pesticide contamination"
    puts "                             Chemicals and toxic materials not properly stored"
    puts "04F - Public Health Hazard - Sewage and liquid waste not properly disposed of"
    puts "04G - Public Health Hazard - Unprotected potentially hazardous food re-served"
    puts "04H - Public Health Hazard - Food not protected from cross-contamination"
    puts "                             Food in contact with toxic material"
    puts "                             Food not protected from adulteration or contamination"
    puts "                             Food not discarded in accordance with HACCP plan"
    puts "04I - Critical - Food other than in sealed packages re-served"
    puts "04J - Critical - Thermometer not provided, [used,] calibrated properly, accessible for use and/or inadequate"
    puts "04K - Critical - Evidence of rats"
    puts "04L - Critical - Evidence of mice"
    puts "04M - Critical - Evidence of roaches"
    puts "04N - Critical - Filth flies"
    puts "04O - Critical - Live animal other than fish in tank or service animal"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "5"
    puts ""
    puts "05A - Public Health Hazard - Sewage disposal system improper or unapproved"
    puts "05B - Public Health Hazard - Harmful noxious gas or vapor detected; CO levels at or exceeding 9 ppm"
    puts "05C - Critical - Food contact surface improperly constructed, located and/or made of unacceptable materials"
    puts "                 Culinary sink or alternative method not provided for washing food"
    puts "05D - Critical - Hand washing facilities not provided or not located where required"
    puts "                 Hand washing facilities not provided within 25 feet of food preparation area or ware washing area"
    puts "                 Hand wash facility not provided with running water, or properly equipped"
    puts "05E - Critical - Toilet facilities not provided for employees"
    puts "                 Toilet facilities not provided for patrons"
    puts "                 Shared patron/employee toilet accessed through kitchen, food prep or storage area"
    puts "05F - Critical - Hot or cold holding equipment not provided or inadequate"
    puts "05G - Critical - Enclosed service area not provided, equipped in mobile food vending commissary"
    puts "05H - Critical - Manual or mechanical tableware, utensil and/or ware washing facilities not provided"
    puts "05I - Critical - Refrigeration unit not equipped with an electronic system"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "6"
    puts ""
    puts "06A - Critical - Food worker does not maintain personal cleanliness"
    puts "                 Fingernails not clean, trimmed, or with nail polish"
    puts "                 Clean outer garment not worn"
    puts "                 Effective hair restraint not worn"
    puts "06B - Critical - Eating in food preparation or service areas"
    puts "                 Smoking tobacco, using e-cigarettes or other substance in establishment"
    puts "06C - Critical - Food not protected from contamination"
    puts "                 Unnecessary traffic through food prep area"
    puts "                 Food not properly protected when stored or displayed"
    puts "                 Condiments for self service not properly dispensed"
    puts "                 Supplies and equipment placed under overhead sewage pipe"
    puts "                 Cooking by FSE on street, sidewalk, except as authorized"
    puts "06D - Critical - Food contact surface not sanitized; and/or not clean to sight and/or touch"
    puts "06E - Critical - In-use food dispensing utensil not properly stored; not provided"
    puts "                 Ice not properly dispensed"
    puts "06F - Critical - Wiping cloth improperly stored and/or sanitized"
    puts "06G - Public Health Hazard - Approved HACCP plan not maintained on premises or not approved"
    puts "06H - Critical - Records and logs not maintained on site"
    puts "06I - Critical - Food not labeled in accordance with the approved HACCP plan"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "7"
    puts ""
    puts "07A - Critical - Obstruction of Department personnel"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "8"
    puts ""
    puts "08A - General - Conditions conducive to pests"
    puts "                Prevention and control measures not used for pest management"
    puts "                Door openings into the establishment from the outside not properly equipped"
    puts "                Pest monitors incorrectly used"
    puts "                Contract with pest exterminator or record of pest extermination activities not kept on premises"
    puts "08B - General - Garbage not properly removed or stored"
    puts "                Garbage receptacles and covers not cleaned after emptying and prior to reuse"
    puts "08C - General - Pesticides not properly labeled, not authorized for use, or improperly used"
    puts "                Open bait station observed"
    puts "                Toxic materials not properly stored"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "9"
    puts ""
    puts "09A - General - Canned food observed dented and not segregated from other consumable foods"
    puts "09B - General - Thawing procedures improper"
    puts "09C - General - Food contact surface improperly constructed and maintained; not easily cleanable"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "10"
    puts ""
    puts "10A - General - Toilet facility not properly maintained"
    puts "                Toilet facility not properly supplied"
    puts "                Toilet room not completely enclosed with self-closing door"
    puts "10B - General - Potable water not protected from backflow, back siphonage or cross-connection"
    puts "                Improper disposal of sewage or liquid waste"
    puts "                Condensation pipes not properly installed or maintained"
    puts "10C - General - Lighting insufficient; inadequate"
    puts "10D - General - Ventilation (mechanical or natural) not provided or inadequate"
    puts "10E - General - Thermometers not provided in cold storage and/or refrigerator"
    puts "                Thermometers not provided in hot storage or holding units"
    puts "10F - General - Flooring improperly constructed and/or maintained"
    puts "                Non-food contact surfaces (wall, ceiling, floors) improperly constructed/maintained"
    puts "                Non-food contact surface (fixtures, decorative material, fans, etc.) not properly maintained or equipment not properly maintained"
    puts "10G - General - Food being processed, prepared, packed, or stored in a private home or apartment."
    puts "10H - General - Hot water manual ware washing inadequate"
    puts "                Manual chemical sanitizing procedure inadequate"
    puts "                High temperature mechanical ware washing inadequate"
    puts "                Mechanical chemical sanitizing procedure inadequate"
    puts "                Test kit not accurate or used for manual dishwashing"
    puts "                Test kit not accurate or used for mechanical dishwashing"
    puts "10I - General - Single service items improperly stored or reused"
    puts "                Drinking straws improperly dispensed"
    puts "10J - General - Wash hands sign not posted"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "11"
    puts ""
    puts "99A - Other Health Code unscored violations"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "12"
    puts ""
    puts "15A - Tobacco vending machine present in a facility other than tavern"
    puts "15B - Tobacco vending machine not 25 feet from door"
    puts "15C - Tobacco vending machine not visible by owner"
    puts "15D - Sign not durable and lacks required information"
    puts "      Sign not posted on machine and not visible to the public"
    puts "15E - Out-of-package sale of tobacco products"
    puts "15F - Employee under 18 years of age selling tobacco products without supervision"
    puts "15G - Sale to persons under 21 observed"
    puts "15H - Sign prohibiting sale of tobacco products to persons under 21 not conspicuously posted"
    puts "15I - Sign prohibiting smoking or using electronic cigarettes not conspicuously posted"
    puts "      Sign permitting smoking or using electronic cigarettes not conspicuously posted"
    puts "      \"No smoking or using electronic cigarettes\" sign not posted with ashtrays in hotels, or at hotel entrances"
    puts "      Sign lettering and color does not meet specifications"
    puts "15J - Ashtrays in smoke-free area"
    puts "15K - Operator failed to make a good faith effort to inform smokers or users of electronic cigarettes of the Smoke-Free Air Act"
    puts "15L - Workplace SFAA policy not prominently posted in workplace"
    puts "15M - Use of tobacco on school premises"
    puts "15N - Selling cigarettes, tobacco products, little cigars for less than listed price or price floor"
    puts "      Distributing tobacco products at less than basic cost"
    puts "15O - Sale of herbal cigarettes to minors"
    puts "15S - Flavored tobacco products sold or offered for sale"
    puts "15T - Flavored tobacco products sold or offered for sale"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "13"
    puts ""
    puts "16A - Cooking oil, shortening, margarine contains 0.5 grams or more of artificial trans fat"
    puts "16B - Nutritional fact labels and/or ingredient label is not maintained on site"
    puts "16C - Calorie information is not posted on menu and menu board"
    puts "16E - Calorie range of food items that come in different flavors and varieties not provided"
    puts "16F - Calorie range of food items that come in different combinations not provided"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "14"
    puts ""
    puts "18A - No currently valid permit, registration or other authorization to operate food service establishment"
    puts "      No currently valid permit, registration or other authorization to operate a temporary food service establishment"
    puts "18B - Submitting false, misleading statements, documents; documents unlawfully reproduced or altered"
    puts "18C - Notice of the Department mutilated, obstructed, or removed"
    puts "18D - Failure to comply with an Order of the Board of Health, Commissioner, or Department"
    puts "18E - Failure to report occurrences of suspected food borne illness to the Department"
    puts "18F - Food Protection Certificate not available for Department inspection"
    puts  "     Permit not conspicuously displayed or posted"
    puts "18G - Manufacture and sell frozen dessert at retail not authorized on permit"
    puts "18H - Operator of shared kitchen allowing user without currently valid permit"
    puts "      Failure of temporary event sponsor to exclude vendor without a currently valid permit"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "15"
    puts ""
    puts "20A - Allergy poster not posted or not in correct location"
    puts "20B - Allergy poster not in languages"
    puts "20C - Allergy poster is not approved by the Department, and it does not contain the required text"
    puts "20D - Choking first aid poster not posted"
    puts "      Alcohol/pregnancy sign not posted"
    puts "      Resuscitation equipment not available"
    puts "      Resuscitation equipment required notice to all patrons not posted"
    puts "20E - Current letter grade or \"Grade Pending\" card not conspicuously posted"
    puts "20F - Current letter grade or \"Grade Pending\" card not posted"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when "16"
    puts ""
    puts "22A - Failure to take reasonable precautions to protect health and safety"
    puts "      Failing to abate or remediate nuisance"
    puts "      Insufficient heat in commercial premises"
    puts "22B - No covered waste receptacle in women’s toilets"
    puts "22C - Light fixtures not shielded, shatterproof, or otherwise protected from accidental breakage"
    puts "22E - Equipment used for ROP not approved by the Department"
    puts "22F - Misbranded, mislabeled packaged food products"
    puts "22G - Possess, sell expanded polystyrene single service articles"
    puts "*****************"
    puts "Press return to return to the violations menu"

    returner = get_input
    vcode_menu(user) if returner

  when ""
    puts ""
    puts "stop it"
    vcode_menu(user)

  else
    puts ""
    puts "UGH NO"
    main_menu(user)

  end
end

def exit
  puts "Bye bye!!!"
  exit!
end
