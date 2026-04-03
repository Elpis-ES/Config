return {
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local ok, _ = pcall(vim.cmd.colorscheme, "base16-tomorrow-night")
      if not ok then
        vim.cmd.colorscheme("default")
      end
    end,
  },
}
