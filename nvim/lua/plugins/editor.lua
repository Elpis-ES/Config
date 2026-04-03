return {
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
  },
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    config = function()
      require("fzf-lua").setup()
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
