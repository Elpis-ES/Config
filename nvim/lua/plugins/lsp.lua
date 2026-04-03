return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "pyright",
          "vimls",
          "yamlls",
          "terraformls",
          "bashls",
          "dockerls",
          "rust_analyzer",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "ms-jpq/coq_nvim" },
    config = function()
      local coq = require("coq")

      local servers = { "pyright", "vimls", "yamlls", "terraformls", "bashls", "dockerls", "rust_analyzer" }
      local capabilities = coq.lsp_ensure_capabilities()
      for _, server in ipairs(servers) do
        vim.lsp.config(server, capabilities)
      end
      vim.lsp.enable(servers)
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    dependencies = { "neovim/nvim-lspconfig", "ms-jpq/coq_nvim" },
    config = function()
      require("clangd_extensions").setup({
        server = require("coq").lsp_ensure_capabilities(),
      })
    end,
  },
}
