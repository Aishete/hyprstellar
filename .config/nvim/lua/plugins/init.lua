return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "clangd",                      -- C/C++ LSP
                "css-lsp",                     -- CSS LSP
                "html-lsp",                    -- HTML LSP
                "intelephense",                -- PHP LSP
                "json-lsp",                    -- JSON LSP
                "lua-language-server",         -- Lua LSP
                "pyright",                     -- Python LSP
                "stylua",                      -- Lua formatter
                "tailwindcss-language-server", -- Tailwind CSS LSP
                "typescript-language-server",  -- TypeScript/JavaScript LSP
            },
        },
    },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n",          desc = "Comment toggle current line" },
            { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
            { "gbc", mode = "n",          desc = "Comment toggle current block" },
            { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
            { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
        },
        config = function(_, opts)
            opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            require("Comment").setup(opts)
        end,
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        opts = {
            suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        }
    },
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && npm install',
        ft = { 'markdown' },
    },
    {
        "mg979/vim-visual-multi",
        branch = "master",
        event = 'VeryLazy'
    },
    {
        "ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap-forward)')
            vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-backward)')
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        config = function()
            require("configs.treesitter_context")
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup(require "configs.nvim-surround")
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "simrat39/rust-tools.nvim",
        dependencies = "neovim/nvim-lspconfig",
        ft = "rust",
        opts = function()
            return require "configs.rust-tools"
        end,
        config = function(_, opts)
            require("rust-tools").setup(opts)
        end
    },
    {
        'saecki/crates.nvim',
        ft = { "toml" },
        tag = 'stable',
        config = function(_, opts)
            local crates = require('crates')
            crates.setup(opts)
            require('cmp').setup.buffer({
                sources = { { name = "crates" } }
            })
            crates.show()
        end,
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local cmp = require "cmp"
            local M = require "nvchad.configs.cmp"
            M.experimental = {
                ghost_text = {
                    hl_group = 'Comment',
                    hl_group_selected = "CmpItemAbbrMatch"
                }
            }
            table.insert(M.sources, { name = "crates" })
            M.completion.completeopt = "menu,menuone,noselect"
            M.mapping["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = false,
            }
            return M
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = require("configs.nvim-tree")
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "html", "css", "javascript", "tsx", "typescript", "json", "cpp", "rust", "markdown", "python" } },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            scope = { char = "┋", highlight = "IblScopeChar" },
        }
    },
    {
        "b0o/schemastore.nvim",
        ensure_installed = { "vscode-json-languageserver" }
    },
    {
        "AckslD/nvim-neoclip.lua",
        event = 'TextYankPost',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            require('neoclip').setup()
        end,
    },
    {
        "folke/which-key.nvim",
        ft = { 'text', "markdown" },
        keys = { "z=" }
    },
    {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        config = function()
            local cmp = require("cmp")
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'cmdline' },
                    { name = 'path' },
                },
                formatting = {
                    format = function(_, vim_item)
                        vim_item.kind = ""
                        return vim_item
                    end,
                }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        require 'nvim-treesitter.configs'.setup(require("configs.TSTextobjects"))
    },
    {
        'stevearc/oil.nvim',
        cmd = "Oil",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            keymaps = {
                ["s"] = false,
                ["f"] = false
            }
        },
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false }
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            background_colour = "#353535",
            cmdline = {
                enabled = true,         -- enables the Noice cmdline UI
                view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
                opts = {},              -- global options for the cmdline. See section on views
                ---@type table<string, CmdlineFormat>
                format = {
                    -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
                    -- view: (default is cmdline view)
                    -- opts: any options passed to the view
                    -- icon_hl_group: optional hl_group for the icon
                    -- title: set to anything or empty string to hide
                    cmdline = { pattern = "^:", icon = "", lang = "vim" },
                    search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                    search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                    filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                    help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                    input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
                    -- lua = false, -- to disable a format, set to `false`
                },
            },
            messages = {
                -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                -- This is a current Neovim limitation.
                enabled = true,              -- enables the Noice messages UI
                view = "notify",             -- default view for messages
                view_error = "notify",       -- view for errors
                view_warn = "notify",        -- view for warnings
                view_history = "messages",   -- view for :messages
                view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
            },
            popupmenu = {
                enabled = true,  -- enables the Noice popupmenu UI
                ---@type 'nui'|'cmp'
                backend = "nui", -- backend to use to show regular cmdline completions
                ---@type NoicePopupmenuItemKind|false
                -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
                kind_icons = {}, -- set to `false` to disable icons
            },
            -- default options for require('noice').redirect
            -- see the section on Command Redirection
            ---@type NoiceRouteConfig
            redirect = {
                view = "popup",
                filter = { event = "msg_show" },
            },
            -- You can add any custom commands below that will be available with `:Noice command`
            ---@type table<string, NoiceCommand>
            commands = {
                history = {
                    -- options for the message history that you get with `:Noice`
                    view = "split",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "" } },
                            { event = "lsp",      kind = "message" },
                        },
                    },
                },
                -- :Noice last
                last = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "" } },
                            { event = "lsp",      kind = "message" },
                        },
                    },
                    filter_opts = { count = 1 },
                },
                -- :Noice errors
                errors = {
                    -- options for the message history that you get with `:Noice`
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = { error = true },
                    filter_opts = { reverse = true },
                },
                all = {
                    -- options for the message history that you get with `:Noice`
                    view = "split",
                    opts = { enter = true, format = "details" },
                    filter = {},
                },
            },
            notify = {
                -- Noice can be used as `vim.notify` so you can route any notification like other messages
                -- Notification messages have their level and other properties set.
                -- event is always "notify" and kind can be any log level as a string
                -- The default routes will forward notifications to nvim-notify
                -- Benefit of using Noice for this is the routing and consistent history view
                enabled = true,
                view = "notify",
            },
            lsp = {
                progress = {
                    enabled = true,
                    -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
                    -- See the section on formatting for more details on how to customize.
                    --- @type NoiceFormat|string
                    format = "lsp_progress",
                    --- @type NoiceFormat|string
                    format_done = "lsp_progress_done",
                    throttle = 1000 / 30, -- frequency to update lsp progress message
                    view = "mini",
                },
                override = {
                    -- override the default lsp markdown formatter with Noice
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                    -- override the lsp markdown formatter with Noice
                    ["vim.lsp.util.stylize_markdown"] = false,
                    -- override cmp documentation with Noice (needs the other options to work)
                    ["cmp.entry.get_documentation"] = false,
                },
                hover = {
                    enabled = true,
                    silent = false, -- set to true to not show a message if hover is not available
                    view = nil,     -- when nil, use defaults from documentation
                    ---@type NoiceViewOptions
                    opts = {},      -- merged with defaults from documentation
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                        throttle = 50,  -- Debounce lsp signature help request by 50ms
                    },
                    view = nil,         -- when nil, use defaults from documentation
                    ---@type NoiceViewOptions
                    opts = {},          -- merged with defaults from documentation
                },
                message = {
                    -- Messages shown by lsp servers
                    enabled = true,
                    view = "notify",
                    opts = {},
                },
                -- defaults for hover and signature help
                documentation = {
                    view = "hover",
                    ---@type NoiceViewOptions
                    opts = {
                        lang = "markdown",
                        replace = true,
                        render = "plain",
                        format = { "{message}" },
                        win_options = { concealcursor = "n", conceallevel = 3 },
                    },
                },
            },
            markdown = {
                hover = {
                    ["|(%S-)|"] = vim.cmd.help,                       -- vim help links
                    ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
                },
                highlights = {
                    ["|%S-|"] = "@text.reference",
                    ["@%S+"] = "@parameter",
                    ["^%s*(Parameters:)"] = "@text.title",
                    ["^%s*(Return:)"] = "@text.title",
                    ["^%s*(See also:)"] = "@text.title",
                    ["{%S-}"] = "@parameter",
                },
            },
            health = {
                checker = true, -- Disable if you don't want health checks to run
            },
            ---@type NoicePresets
            presets = {
                -- you can enable a preset by setting it to true, or a table that will override the preset config
                -- you can also add custom presets that you can enable/disable with enabled=true
                bottom_search = false,         -- use a classic bottom cmdline for search
                command_palette = false,       -- position the cmdline and popupmenu together
                long_message_to_split = false, -- long messages will be sent to a split
                inc_rename = false,            -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,        -- add a border to hover docs and signature help
            },
            throttle = 1000 / 30,              -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
            ---@type NoiceConfigViews
            views = {}, ---@see section on views
            ---@type NoiceRouteConfig[]
            routes = {}, --- @see section on routes
            ---@type table<string, NoiceFilter>
            status = {}, --- @see section on statusline components
            ---@type NoiceFormatOptions
            format = {}, --- @see section on formatting
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify"
        }
    },
    {
        "karb94/neoscroll.nvim",
        opts = function()
            require('neoscroll').setup({ mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>' } })
        end,
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "VeryLazy",
        opts = {
            -- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
            -- provider_selector = function(bufnr, filetype, buftype)
            --   return { "treesitter", "indent" }
            -- end,
            open_fold_hl_timeout = 400,
            close_fold_kinds_for_ft = { "imports", "comment" },
            preview = {
                win_config = {
                    border = { "", "─", "", "", "", "─", "", "" },
                    winhighlight = "Normal:Folded",
                    winblend = 0,
                },
                mappings = {
                    scrollU = "<C-u>",
                    scrollD = "<C-d>",
                    jumpTop = "[",
                    jumpBot = "]",
                },
            },
        },
        init = function()
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
            vim.o.foldcolumn = "1" -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        config = function(_, opts)
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local suffix = ("  %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                local rAlignAppndx = math.max(math.min(vim.api.nvim_win_get_width(0), width - 1) - curWidth - sufWidth, 0)
                suffix = (" "):rep(rAlignAppndx) .. suffix
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end
            opts["fold_virt_text_handler"] = handler
            require("ufo").setup(opts)
            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
            vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
            vim.keymap.set("n", "K", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    -- vim.lsp.buf.hover()
                    vim.cmd [[ Lspsaga hover_doc ]]
                end
            end)
        end,
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^5',
        lazy = false,
        ft = "rust",
        config = function()
            local mason_registry = require('mason-registry')
            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
            local cfg = require('rustaceanvim.config')

            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
            }
        end
    },
    {
        'rust-lang/rust.vim',
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    {
        'mfussenegger/nvim-dap',
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        'saecki/crates.nvim',
        ft = { "toml" },
        config = function()
            require("crates").setup {
                completion = {
                    cmp = {
                        enabled = true
                    },
                },
            }
            require('cmp').setup.buffer({
                sources = { { name = "crates" } }
            })
        end
    },
    {
        '2kabhishek/markit.nvim',
        config = require('plugins.tools.marks').setup,
        event = { 'BufReadPre', 'BufNewFile' },
    },
}
