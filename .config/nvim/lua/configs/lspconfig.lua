require("nvchad.configs.lspconfig").defaults()
local base = require("nvchad.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

-- Default setup arguments for most LSPs
local setup_arg = {
    on_attach = on_attach,
    capabilities = capabilities,
}

-- TypeScript/JavaScript (typescript-language-server)
lspconfig.ts_ls.setup(vim.tbl_extend("force", setup_arg, {
    init_options = {
        maxTsServerMemory = 4096,
    },
}))

-- C/C++ (clangd)
lspconfig.clangd.setup(vim.tbl_extend("force", setup_arg, {}))

-- PHP (intelephense)
lspconfig.intelephense.setup(vim.tbl_extend("force", setup_arg, {
    format_on_save = false,
}))

-- HTML (html-lsp)
lspconfig.html.setup(setup_arg)

-- CSS (css-lsp)
lspconfig.cssls.setup(setup_arg)

-- Python (pyright)
lspconfig.pyright.setup(vim.tbl_extend("force", setup_arg, {
    filetypes = { "python" },
}))

-- JSON (json-lsp)
lspconfig.jsonls.setup(vim.tbl_extend("force", setup_arg, {
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
}))

-- Lua (lua-language-server)
lspconfig.lua_ls.setup(vim.tbl_extend("force", setup_arg, {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }, -- Recognize Vim globals
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true), -- Neovim runtime files
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
}))

-- Tailwind CSS (tailwindcss-language-server)
lspconfig.tailwindcss.setup(setup_arg)
