return {
    { import = "nvchad.blink.lazyspec" },
    {
        "nvchad/ui",
        enbaled = false,
    },
    {
        "suryansh-dey/ui",
        lazy = false,
        config = function()
            require "nvchad"
        end,
    },
    {
        "Saghen/blink.cmp",
        opts = {
            cmdline = {
                completion = {
                    menu = { auto_show = true },
                    list = { selection = { preselect = false, auto_insert = true } }
                },
            },
        }
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "rust-analyzer",
                "jdtls",
                "typescript-language-server",
                "clangd",
                "html-lsp",
                "css-lsp",
                "pyright",
                "tailwindcss"
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
        "ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            vim.keymap.set({ 'n', 'x', 'o' }, 'm', '<Plug>(leap-forward)')
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
            require("nvchad.configs.lspconfig").defaults()
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
            crates.show()
        end,
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
    },
    {
        "nvim-tree/nvim-tree.lua",
        opts = require("configs.nvim-tree")
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "html", "css", "javascript", "tsx", "typescript", "json", "cpp", "rust", "markdown", "python", "java" } },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            scope = { char = "┋" },
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

        "nvim-telescope/telescope.nvim",
        opts = {
            defaults = {
                file_ignore_patterns = { "node_modules" }
            }
        }
    },
    {
        "nvim-orgmode/telescope-orgmode.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-orgmode/orgmode",
            "nvim-telescope/telescope.nvim",
        }
    },
    {
        "folke/which-key.nvim",
        ft = { 'text', "markdown" },
        keys = { "z=" }
    },
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = {
            "kevinhwang91/promise-async",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            vim.o.foldenable = true
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            require('ufo').setup({
                provider_selector = function()
                    return { 'treesitter', 'indent' }
                end
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
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false }
    },
    {
        "suryansh-dey/to-future.nvim",
        event = "VeryLazy",
        opts = {}
    },
    {
        "mg979/vim-visual-multi",
        branch = "master",
        event = 'VeryLazy'
    },
    -- {
    --     "epwalsh/obsidian.nvim",
    --     version = "*", -- recommended, use latest release instead of latest commit
    --     lazy = false,
    --     ft = "markdown",
    --     -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    --     -- event = {
    --     --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --     --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --     --   -- refer to `:h file-pattern` for more examples
    --     --   "BufReadPre path/to/my-vault/*.md",
    --     --   "BufNewFile path/to/my-vault/*.md",
    --     -- },
    --     dependencies = {
    --         -- Required.
    --         "nvim-lua/plenary.nvim",
    --
    --         -- see below for full list of optional dependencies 👇
    --     },
    --     opts = {
    --         workspaces = {
    --             {
    --                 name = "work",
    --                 path = "~/Documents/obsidian/",
    --             },
    --         },
    --
    --         -- see below for full list of options 👇
    --     },
    -- },
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/Documents/obsidian/**/*',
                org_startup_folded = 'inherit',
                org_ellipsis = '***',
                org_default_notes_file = '~/Documents/obsidian/orgfiles/refile.org',
                org_capture_templates = {
                    r = {
                        description = "Task",
                        template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
                        target = "~/Documents/obsidian/orgfiles/Tasks.org",
                    },
                    j = {
                        description = 'Journal',
                        template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
                        target = '~/~/Documents/obsidian/orgfiles/journal.org'
                    },
                }
            })
            require('blink.cmp').setup({
                sources = {
                    per_filetype = {
                        org = { 'orgmode' }
                    },
                    providers = {
                        orgmode = {
                            name = 'Orgmode',
                            module = 'orgmode.org.autocompletion.blink',
                            fallbacks = { 'buffer' },
                        },
                    },
                },
            })
            require('telescope').setup()
            require('telescope').load_extension('orgmode')

            require("headlines").setup()
            require('org-super-agenda').setup()

            -- add ~org~ to ignore_install
            --
            --
            --require('nvim-treesitter.configs').setup({
            --
            --ensure_installed = 'all',
            -- ignore_install = { 'org' },
            --:})
            vim.keymap.set('n', '<leader>rb', require('telescope').extensions.orgmode.refile_heading)
            vim.keymap.set('n', '<leader>foh', require('telescope').extensions.orgmode.search_headings)
            vim.keymap.set('n', '<leader>li', require('telescope').extensions.orgmode.insert_link)
            vim.keymap.set('n', '<leader>osa', '<cmd>OrgSuperAgenda<cr>')
            vim.keymap.set('n', '<leader>osf', '<cmd>OrgSuperAgenda!<cr>') -- fullscreen
        end,
    }, {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
},
    {
        "michaelb/sniprun",
        branch = "master",
        event = 'VeryLazy',
        build = "sh install.sh",
        -- do 'sh install.sh 1' if you want to force compile locally
        -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

        config = function()
            require("sniprun").setup({
                selected_interpreters = { "JS_TS_deno" },
                repl_enable = { "JS_TS_deno" },
                vim.api.nvim_set_keymap('v', '<leader>rr', '<Plug>SnipRun', { silent = true }),
                vim.api.nvim_set_keymap('v', '<leader>ri', '<Plug>Snipinfo', { silent = true })
            })
        end,
    },
    {
        'hamidi-dev/org-super-agenda.nvim',
        dependencies = {
            'nvim-orgmode/orgmode',                            -- required
            { 'lukas-reineke/headlines.nvim', config = true }, -- optional nicety
        },
        config = function()
            require('org-super-agenda').setup({
                -- Where to look for .org files
                org_files           = { '~/Documents/obsidian/orgfiles/refile.org' },
                org_directories     = { '~/Documents/obsidian/' }, -- recurse for *.org
                exclude_files       = {},
                exclude_directories = {},

                -- TODO states + their quick filter keymaps and highlighting
                todo_states         = {
                    { name = 'TODO',     keymap = 'ot', color = '#FF5555', strike_through = false, fields = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' } },
                    { name = 'PROGRESS', keymap = 'op', color = '#FFAA00', strike_through = false, fields = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' } },
                    { name = 'WAITING',  keymap = 'ow', color = '#BD93F9', strike_through = false, fields = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' } },
                    { name = 'DONE',     keymap = 'od', color = '#50FA7B', strike_through = true,  fields = { 'filename', 'todo', 'headline', 'priority', 'date', 'tags' } },
                },

                -- Agenda keymaps (inline comments explain each)
                keymaps             = {
                    filter_reset      = 'oa', -- reset all filters
                    toggle_other      = 'oo', -- toggle catch-all "Other" section
                    filter            = 'of', -- live filter (exact text)
                    filter_fuzzy      = 'oz', -- live filter (fuzzy)
                    filter_query      = 'oq', -- advanced query input
                    undo              = 'u',  -- undo last change
                    reschedule        = 'cs', -- set/change SCHEDULED
                    set_deadline      = 'cd', -- set/change DEADLINE
                    cycle_todo        = 't',  -- cycle TODO state
                    reload            = 'r',  -- refresh agenda
                    refile            = 'R',  -- refile via Telescope/org-telescope
                    hide_item         = 'x',  -- hide current item
                    preview           = 'K',  -- preview headline content
                    reset_hidden      = 'X',  -- clear hidden list
                    toggle_duplicates = 'D',  -- duplicate items may appear in multiple groups
                    cycle_view        = 'ov', -- switch view (classic/compact)
                },

                -- Window/appearance
                window              = {
                    width             = 0.8,
                    height            = 0.7,
                    border            = 'rounded',
                    title             = 'Org Super Agenda',
                    title_pos         = 'center',
                    margin_left       = 0,
                    margin_right      = 0,
                    fullscreen_border = 'none', -- border style when using fullscreen
                },

                -- Group definitions (order matters; first match wins unless allow_duplicates=true)
                groups              = {
                    { name = '📅 Today', matcher = function(i) return i.scheduled and i.scheduled:is_today() end, sort = { by = 'priority', order = 'desc' } },
                    {
                        name = '🗓️ Tomorrow',
                        matcher = function(i)
                            return i.scheduled and
                                i.scheduled:days_from_today() == 1
                        end
                    },
                    {
                        name = '☠️ Deadlines',
                        matcher = function(i)
                            return i.deadline and i.todo_state ~= 'DONE' and
                                not i:has_tag('personal')
                        end,
                        sort = { by = 'deadline', order = 'asc' }
                    },
                    {
                        name = '⭐ Important',
                        matcher = function(i)
                            return i.priority == 'A' and
                                (i.deadline or i.scheduled)
                        end,
                        sort = { by = 'date_nearest', order = 'asc' }
                    },
                    {
                        name = '⏳ Overdue',
                        matcher = function(i)
                            return i.todo_state ~= 'DONE' and
                                ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
                        end,
                        sort = { by = 'date_nearest', order = 'asc' }
                    },
                    { name = '🏠 Personal', matcher = function(i) return i:has_tag('personal') end },
                    { name = '💼 Work', matcher = function(i) return i:has_tag('work') end },
                    {
                        name = '📆 Upcoming',
                        matcher = function(i)
                            local days = require('org-super-agenda.config').get().upcoming_days or 10
                            local d1 = i.deadline and i.deadline:days_from_today()
                            local d2 = i.scheduled and i.scheduled:days_from_today()
                            return (d1 and d1 >= 0 and d1 <= days) or (d2 and d2 >= 0 and d2 <= days)
                        end,
                        sort = { by = 'date_nearest', order = 'asc' }
                    },
                },

                -- Defaults & behavior
                upcoming_days       = 10,
                hide_empty_groups   = true,      -- drop blank sections
                keep_order          = false,     -- keep original org order (rarely useful)
                allow_duplicates    = false,     -- if true, an item can live in multiple groups
                group_format        = '* %s',    -- group header format
                other_group_name    = 'Other',
                show_other_group    = false,     -- show catch-all section
                show_tags           = true,      -- draw tags on the right
                show_filename       = true,      -- include [filename]
                heading_max_length  = 70,
                persist_hidden      = false,     -- keep hidden items across reopen
                view_mode           = 'classic', -- 'classic' | 'compact'

                classic             = { heading_order = { 'filename', 'todo', 'priority', 'headline' }, short_date_labels = false, inline_dates = true },
                compact             = { filename_min_width = 10, label_min_width = 12 },

                -- Global fallback sort for groups that omit `sort`
                group_sort          = { by = 'date_nearest', order = 'asc' },

                debug               = false,
            })
        end,
    }

}
