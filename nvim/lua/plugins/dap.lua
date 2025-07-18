return {
  'nvim-neotest/nvim-nio',

  {
    "igorlfs/nvim-dap-view",
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      winbar = {
        controls = {
          enabled = true,
          position = 'left',
        },
      },
      windows = {
        position = "right",
        terminal = {
          position = "below",
          hide = {},
          start_hidden = false,
        },
      }
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    enabled = false,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end
  },

  -- Mason for managing installations
  {
    'williamboman/mason.nvim',
    event = 'VeryLazy',
    config = function()
      require('mason').setup()
    end,
  },

  -- Automatically install DAPs with mason
  {
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('mason-nvim-dap').setup({
        -- A list of debuggers to ensure are installed.
        ensure_installed = { 'js-debug-adapter' },
        -- Automatically install configured debuggers.
        automatic_installation = true,
      })
    end,
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',

      -- JS/TS in chrome, edge, firefox, node
      {
        "mxsdev/nvim-dap-vscode-js",
        tag = "v1.1.0",
      },
      {
        "microsoft/vscode-js-debug",
        tag = "v1.74.1",
        build = "npm i --legacy-peer-deps && npm run compile vsDebugServerBundle && mv dist out"
      }
    },
    event = "VeryLazy",
    keys = {
      { "<leader>du", function() require("dap-view").toggle({}) end,                                        desc = "Dap UI" },
      -- { "<leader>de", function() require("dapui").eval() end,                                               desc = "Evaluate",            mode = { "n", "v" } },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>ds", function() require("dap").sessions() end,                                             desc = "DAP Sessions" },
    },
    config = function()
      local dap = require("dap")

      -- require("dap-vscode-js").setup({
      --   debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      --   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      -- });

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = 'node',
          args = {
            -- Path to the js-debug-adapter installation from mason.nvim
            vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            "${port}" -- The same port as above
          },
          -- command = "js-debug-adapter", -- As I'm using mason, this will be in the path
          -- args = { "${port}" },
        }
      }

      for _, language in ipairs({ "typescriptreact", "javascriptreact", "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "${file}",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          }
        }
      end
    end
  }
}
