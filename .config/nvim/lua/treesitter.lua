local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end

ts_config.setup {
   ensure_installed = {
      "go",
      "typescript",
      "hcl",
      "json",
      "bash",
      "svelte"
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
}
