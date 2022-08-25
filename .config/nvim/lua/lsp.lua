local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
     vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
     vim.api.nvim_buf_set_option(bufnr, ...)
  end
   print("LSP started")
   vim.lsp.set_log_level(0)

   -- Enable completion triggered by <c-x><c-o>
   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

   -- Mappings.
   local opts = { noremap = true, silent = true }

   -- See `:help vim.lsp.*` for documentation on any of the below functions
   buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
   --buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
   buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
   buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
   --buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
   buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
   buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
   buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
   buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
   buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
   --buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
   buf_set_keymap("n", "<space>D", "<cmd>Telescope lsp_type_definitions<CR>", opts)
   buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
   --buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
   buf_set_keymap("n", "<space>ca", "<cmd>Telescope lsp_code_actions<CR>", opts)
   --buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
   buf_set_keymap("n", "gr", "<cmd>TroubleToggle lsp_references<CR>", opts)
   --buf_set_keymap("n", "ge", "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>", opts)
   buf_set_keymap("n", "ge", "<cmd>TroubleToggle document_diagnostics<CR>", opts)
   buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
   buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
   --buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
   buf_set_keymap("n", "<leader>q", "<cmd>Telescope diagnostics<CR>", opts)
   buf_set_keymap("n", "<space>fb", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
   --buf_set_keymap("v", "<space>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
   buf_set_keymap("v", "<leader>ca", "<cmd>Telescope lsp_range_code_actions<CR>", opts)
   buf_set_keymap("n", "gs", ":TSLspOrganize<CR>", opts)
   buf_set_keymap("n", "gi", ":TSLspRenameFile<CR>", opts)
   buf_set_keymap("n", "go", ":TSLspImportAll<CR>", opts)

   if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

-- replace the default lsp diagnostic symbols
local function lspSymbol(name, icon)
   vim.fn.sign_define("LspDiagnosticsSign" .. name, { text = icon, numhl = "LspDiagnosticsDefault" .. name })
end

lspSymbol("Error", "")
lspSymbol("Information", "")
lspSymbol("Hint", "")
lspSymbol("Warning", "")

local lsp_publish_diagnostics_options = {
   --virtual_text = {
   --   prefix = "",
   --   spacing = 0,
   --},
   signs = true,
   underline = true,
   update_in_insert = false, -- update diagnostics insert mode
}
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics,
   lsp_publish_diagnostics_options
)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
   border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
   border = "single",
})

-- suppress error messages from lang servers
vim.notify = function(msg, log_level, _opts)
   if msg:match "exit code" then
      return
   end
   if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
   else
      vim.api.nvim_echo({ { msg } }, true, {})
   end
end


local lspconfig = require "lspconfig"
-- lspconfig.tsserver.setup({
--     on_attach = function(client, bufnr)
--         client.resolved_capabilities.document_formatting = false
--         client.resolved_capabilities.document_range_formatting = false
--         local ts_utils = require("nvim-lsp-ts-utils")
--         ts_utils.setup({
--             eslint_bin = "eslint_d",
--             eslint_enable_diagnostics = true,
--             eslint_enable_code_actions = true,
--             enable_formatting = true,
--             formatter = "prettier",
--         })
--         ts_utils.setup_client(client)
-- 
--         on_attach(client, bufnr)
--     end,
-- })require("null-ls").config({})
-- lspconfig["null-ls"].setup({ on_attach = on_attach })

--lspservers with default config
--local servers = { "denols", "terraformls" }
local servers = { "tsserver", "terraformls", "gopls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  })
end
