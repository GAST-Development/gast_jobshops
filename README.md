# Job Shops Script for ESX
By G.A.S.T. Develepoment - andrejkm

This repository provides a job shop system for the ESX framework using `ox_inventory` for inventory and shop management. The script supports both server-side and client-side interactions for managing job-specific shops and storage.

## Features
✅ **ESX and ox_inventory integration**

✅ **NPC-based shop system with customizable blips**

✅ **Item pricing and metadata handling**

✅ **Support for `ox_target` for interaction zones**

✅ **Customizable notifications (`ox_lib` and `esx_default`)**

## Installation
1. Download and extract the files into your FiveM server's resources directory.
2. Add the resource to your `server.cfg`:
   ```plaintext
   ensure gast_jobshops
   ```
3. Ensure you have the `es_extended` and `ox_inventory` resources properly installed and running.

## Configuration
The script uses a `Config.Shops` table where each shop is defined with:
- **NPC spawn data** (model, location, heading)
- **Blip settings** (icon, color, scale)
- **Interaction zones** (stash and shop areas)

You can customize the shop settings in the `config.lua` file.

## Usage

https://drive.google.com/file/d/1Uv9RrCYwZPFr7vLdez2D-Z29FcDI7sL2/view?usp=sharing

### Adding a New Shop
To add a new shop:
1. Edit the `Config.Shops` table in `config.lua`.
2. Define the shop's NPC, blip, and stash settings.

### Item Management
- **Set item price:** Use the event `gast_jobshops:setProductPrice`.
- **Refresh shop inventory:** Use the event `gast_jobshops:refreshShop`.

### Notifications
Notifications can be configured via the `Config.notifications` parameter:
- `"ox_lib"` for `ox_lib` notifications
- `"esx_default"` for ESX's default notifications

## Events and Hooks
### Client Events
- `gast_jobshops:setProductPrice`: Triggered to set the price of an item in the shop.
- `gast_jobshops:stash`: Opens the stash inventory.
- `gast_jobshops:store<shopType>`: Opens the shop inventory.

### Server Events
- `gast_jobshops:refreshShop`: Refreshes the shop inventory.
- `gast_jobshops:setData`: Sets item price and metadata.

## Dependencies
- `es_extended`
- `ox_inventory`
- `ox_target`
- `ox_lib`

## Support
For issues or suggestions, please open create an issue on the GitHub repository.

