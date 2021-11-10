local M = {}
  M.setup_lsp = function(attach, capabilities) 
    local lspconfig = require "lspconfig"
    -- lspservers with default config
    local servers = { "html", "tsserver" }
    for _, lsp in ipairs(servers) do    
      lspconfig[lsp].setup {   
        on_attach = attach,   
        capabilities = capabilities,    
        flags = {      
          debounce_text_changes = 150,   
        },  
      } 
    end 
 
    lspconfig.terraformls.setup{
      on_attach=custom_attach;
      capabilities = capabilities;
      flags = {
          debounce_text_changes = 150,
      };
      filetypes = { "tf" };
      cmd = {'terraform-ls', 'serve'}
    }
  end
return M
