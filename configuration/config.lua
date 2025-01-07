Config = {}

Config.Locale = GetConvar('esx:locale', 'en')

Config.Shops = {
    ['global_trans'] = { 
        label = 'Global Trans Predajna',
        type = 'global_trans',  -- Tu pridávame typ obchodu
        blip = {
            enabled = true,
            coords = vec3(-1202.1899, -1462.5983, 4.3739),
            sprite = 477,
            color = 76,
            scale = 0.7,
            string = 'Global Trans Predajna'
        },
        npcshopspawn = {
            enabled = true,
            pedcoords = vec3(-1206.2247, -1460.4371, 3.3739),
            heading = 301.01,
            hex = 0x3E8417BC, 
            name = "MP_M_ExecPA_01"
        },
        locations = {
            stash = {
                enabled = true,
                coords = vec3(-1199.9203, -1464.0659, 4.3739),
                groups = 'global_trans',
                range = 1.0
            },
            shop = {
                enabled = true,
                coords = vec3(-1205.4404, -1460.1884, 4.3911),
                range = 1.0
            }
        }
    },
    ['liehovar'] = { 
        label = 'Liehovar Predajna',
        type = 'liehovar',  -- Tu pridávame typ obchodu
        blip = {
            enabled = true,
            coords = vec3(-1228.8452, -1436.7335, 4.3739),
            sprite = 827,
            color = 18,
            scale = 0.8,
            string = 'Liehovar Predajna'
        },
        npcshopspawn = {
            enabled = true,
            pedcoords = vec3(-1224.8590, -1439.3011, 3.3739),
            heading = 128.53,
            hex = 0x26F067AD, 
            name = "S_M_M_FIBOffice_02"
        },
        locations = {
            stash = {
                enabled = true,
                coords = vec3(-1231.3289, -1435.8845, 4.3739),
                groups = 'liehovar',
                range = 1.0
            },
            shop = {
                enabled = true,
                coords = vec3(-1225.9629, -1439.5559, 4.3739),
                range = 1.0
            }
        }
    },
    ['farma'] = { 
        label = 'Farma Predajna',
        type = 'farma',  -- Tu pridávame typ obchodu
        blip = {
            enabled = true,
            coords = vec3(-1251.1653, -1440.4678, 4.3739),
            sprite = 514,
            color = 2,
            scale = 0.7,
            string = 'Farma Predajna'
        },
        npcshopspawn = {
            enabled = true,
            pedcoords = vec3(-1253.3129, -1444.7531, 3.3739),
            heading = 29.05,
            hex = 0xC0DB04CF, 
            name = "CSB_Ortega"
        },
        locations = {
            stash = {
                enabled = true,
                coords = vec3(-1249.8673, -1438.3464, 4.3739),
                groups = 'farma',
                range = 1.0
            },
            shop = {
                enabled = true,
                coords = vec3(-1253.6775, -1443.8947, 4.3739),
                range = 1.0
            }
        }
    }
}
