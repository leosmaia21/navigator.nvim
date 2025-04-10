local navigator = require("navigator.core")

-- Setup function for configuration
local function setup(opts)
    opts = opts or {}

    -- Configure showjumpkeys (for lualine)
    navigator.showjumpkeys = opts.showjumpkeys ~= false -- Default to true

    -- Update lualine_keys if provided
    if opts.lualine_keys then
        navigator.lualine_keys = opts.lualine_keys
    end

    -- Set up commands
    vim.api.nvim_create_user_command("NavOpen", navigator.launch_navigator, {})
    vim.api.nvim_create_user_command("NavAdd", navigator.addfile, {})
    vim.api.nvim_create_user_command("NavClear", navigator.cleandata, {})
    vim.api.nvim_create_user_command("NavPrint", navigator.printdata, {})
end

return {
    setup = setup,
    launch_navigator = navigator.launch_navigator,
    addfile = navigator.addfile,
    goto = navigator.goto,
    cleandata = navigator.cleandata,
    printdata = navigator.printdata,
    lualine = navigator.lualine,
}
