-- ~/.config/nvim/lua/navigator/core.lua
local M = {}

-- File handling functions
local function tablesave(tbl, filename)
    local json = vim.json.encode(tbl)
    local file, err = io.open(filename, "wb")
    if err then return err end
    file:write(json)
    file:close()
end

local function tableload(sfile)
    local file = io.open(sfile, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return vim.json.decode(content)
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

-- Module setup
M.data = {}
M._loaded = false
M._buf, M._win = nil, nil
M.lualine_keys = {"q", "w", "e", "r"} -- Default lualine labels
local cwd = vim.fn.getcwd()
local cache = vim.fn.stdpath("cache")
local datafile = cache .. "/navigator.files"

if file_exists(datafile) then
    M.data = tableload(datafile) or {}
end
M.data[cwd] = M.data[cwd] or {}

local function is_only_whitespace(str)
    return str:match("^%s*$") ~= nil
end

M.group = vim.api.nvim_create_augroup("Navigator", { clear = true })

function M.launch_navigator()
    local width = vim.o.columns
    local height = vim.o.lines
    local float_width = 50
    local float_height = 10
    local row = math.floor((height - float_height) / 2)
    local col = math.floor((width - float_width) / 2)

    if not M._loaded then
        M._buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(M._buf, "bufhidden", "hide")
    end
    vim.api.nvim_buf_set_lines(M._buf, 0, -1, false, M.data[cwd] or {})

    M._win = vim.api.nvim_open_win(M._buf, true, {
        border = "rounded",
        relative = "editor",
        style = "minimal",
        height = float_height,
        width = float_width,
        row = row,
        col = col,
    })

    local keymaps_opts = { silent = true, buffer = M._buf }
    vim.keymap.set("n", "<ESC>", function() vim.api.nvim_win_hide(M._win) end, keymaps_opts)
    vim.keymap.set("n", "q", function() vim.api.nvim_win_hide(M._win) end, keymaps_opts)
    vim.keymap.set("n", "<CR>", function()
        local current_line = vim.api.nvim_get_current_line()
        vim.api.nvim_win_hide(M._win)
        if vim.fn.expand("%:.") ~= current_line and not is_only_whitespace(current_line) then
            vim.cmd.edit(current_line)
        end
    end, keymaps_opts)

    vim.api.nvim_create_autocmd("BufLeave", {
        group = M.group,
        buffer = M._buf,
        callback = function()
            local tmp = vim.api.nvim_buf_get_lines(M._buf, 0, -1, false)
            M.data[cwd] = {}
            local idx = 1
            for _, k in pairs(tmp) do
                if not is_only_whitespace(k) then
                    M.data[cwd][idx] = k
                    idx = idx + 1
                end
            end
            tablesave(M.data, datafile)
        end
    })

    M._loaded = true
end

function M.goto(number)
    local file = M.data[cwd][number]
    if file and vim.fn.expand("%:.") ~= file and #M.data[cwd] >= number then
        vim.cmd.edit(file)
    end
end

function M.addfile()
    local current_file = vim.fn.expand("%:.")
    if is_only_whitespace(current_file) or current_file == "" then return end
    for _, v in pairs(M.data[cwd]) do
        if v == current_file then return end
    end
    table.insert(M.data[cwd], current_file)
    tablesave(M.data, datafile)
end

function M.printdata()
    print(vim.inspect(M.data))
end

function M.cleandata()
    M.data = {}
    M.data[cwd] = {}
    tablesave(M.data, datafile)
end

M.showjumpkeys = true
function M.lualine()
    local string = ""
    local idx = 1
    for _, k in pairs(M.data[cwd] or {}) do
        if idx <= #M.lualine_keys and M.showjumpkeys then
            string = string .. " " .. M.lualine_keys[idx]:upper() .. " " .. k .. " |"
            idx = idx + 1
        else
            string = string .. " " .. k .. " |"
        end
    end
    return string
end

return M
