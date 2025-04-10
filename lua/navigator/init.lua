-- ~/.config/nvim/lua/navigator/init.lua
local navigator = require("navigator.core")

-- Setup function for configuration
local function setup(opts)
    opts = opts or {}
    navigator.showjumpkeys = opts.showjumpkeys ~= false  -- Default to true
    if opts.jumpkeys then
        navigator.jumpkeys = opts.jumpkeys
    end
end

-- User commands
vim.api.nvim_create_user_command("NavOpen", navigator.launch_navigator, {})
vim.api.nvim_create_user_command("NavAdd", navigator.addfile, {})
vim.api.nvim_create_user_command("NavClear", navigator.cleandata, {})
vim.api.nvim_create_user_command("NavPrint", navigator.printdata, {})

-- -- Default keymappings
-- vim.keymap.set("n", "<leader>n", navigator.launch_navigator, { desc = "Open Navigator" })
-- vim.keymap.set("n", "<leader>na", navigator.addfile, { desc = "Add file to Navigator" })
-- for i, key in ipairs(navigator.jumpkeys) do
--     vim.keymap.set("n", "<leader>" .. key, function() navigator.goto(i) end, 
--         { desc = "Go to file " .. i })
-- end

return {
    setup = setup,
    launch_navigator = navigator.launch_navigator,
    addfile = navigator.addfile,
    goto = navigator.goto,
    cleandata = navigator.cleandata,
    printdata = navigator.printdata,
    lualine = navigator.lualine,
}
