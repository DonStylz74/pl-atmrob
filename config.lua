lib.locale()
Config = {}

-- Item names for hacking and drilling
Config.HackingItem = false  -- Default item name for hacking
Config.DrillItem = false  -- Default item name for drilling

-- Enable or disable ATM robbery actions (hacking and drilling)
Config.EnableHacking = true  -- Set to true to enable ATM hacking
Config.EnableDrilling = true  -- Set to true to enable ATM drilling

-- If you disable this the cash will not be dropped on the ground and will be added to your inventory directly
Config.MoneyDrop = true

Config.AtmModels = {'prop_fleeca_atm', 'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}

Config.Notify = 'ox' --'ox', 'esx', 'okok','qb','wasabi','brutal_notify',custom

Config.Target = 'ox-target' --qb-target, ox-target

Config.Hacking = {
    Minigame = 'ox_lib', --utk_fingerprint, ox_lib
    InitialHackDuration = 2000, --2 seconds
    LootAtmDuration = 20000 --20 seconds
}

Config.CooldownTimer = 60 -- default 10 minutes | 60 = 1 minute

Config.Reward = {
    -- The account type where the reward is credited. Can be:
    -- 'bank' for bank account, 'cash' for cash in hand, or 'dirty' for dirty money.
    account = 'dirty',  
    -- The value of each cash pile (in game currency).
    -- This determines how much each cash pile is worth when dropped during the robbery.
    cash_prop_value = 100,  
    -- The total reward value for completing the robbery.
    -- This value is used when 'MoneyDrop' is false and determines the total reward.
    reward = 1000,  
    -- The number of cash piles that will be dropped during the hack action.
    -- This is how many piles the player will pick up when they hack the ATM.
    hack_cash_pile = 10,  
    -- The number of cash piles that will be dropped during the drill action.
    -- This is how many piles the player will pick up when they drill the ATM.
    drill_cash_pile = 5,  
}


Config.Police = {
    notify = true,
    required = 0,
    Job = {'police'},
}

--default for inbuilt
--ps for ps-dispatch
--aty for aty_disptach
--qs for qausar dispatch
--rcore for rcore dispatch
--os-dispatch for os-disptachv2
--custom for your own

Config.Dispatch = 'default'


