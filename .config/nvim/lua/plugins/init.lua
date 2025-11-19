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
            }
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
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = false,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "work",
                    path = "~/Documents/obsidian/",
                },
            },

            -- see below for full list of options 👇
        },
    },
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            -- Setup orgmode
            require('orgmode').setup({
                org_agenda_files = '~/Documents/obsidian/**/*',
                org_default_notes_file = '~/Documents/obsidian/orgfiles/refile.org',
                org_capture_templates = {
                    r = {
                        description = "Repo",
                        template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
                        target = "~/Documents/obsidian/orgfiles/repos.org",
                    }
                }
            })

            -- add ~org~ to ignore_install
            --require('nvim-treesitter.configs').setup({
            --ensure_installed = 'all',
            -- ignore_install = { 'org' },
            --:})
        end,
    }
}
