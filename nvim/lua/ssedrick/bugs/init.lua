local dap = require("dap")
local dapui = require("dapui")
local daptext = require("nvim-dap-virtual-text")

daptext.setup()
dapui.setup({
    layouts = {
        {
            elements = {
                "console",
            },
            size = 7,
            position = "bottom",
        },
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "watches",
            },
            size = 40,
            position = "left",
        }
    },
})

require("ssedrick.bugs.python")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open(1)
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local set_keymap = vim.keymap.set

local opts = { noremap = true }
set_keymap("n", "<Up>", function()
    dap.continue()
end, opts)
set_keymap("n", "<Down>", function()
    dap.step_over()
end, opts)
set_keymap("n", "<Right>", function()
    dap.step_into()
end, opts)
set_keymap("n", "<Left>", function()
    dap.step_out()
end, opts)

set_keymap("n", "<leader>b", function()
    dap.toggle_breakpoint()
end, opts)

set_keymap("n", "<leader>rc", function()
    dap.run_to_cursor()
end, opts)
