local function collapse_or_parent(state)
  local node = state.tree:get_node()
  if (node.type == "directory" or node:has_children()) and node:is_expanded() then
    state.commands.toggle_node(state)
  else
    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
  end
end

local function expand_or_child(state)
  local node = state.tree:get_node()
  if node.type == "directory" or node:has_children() then
    if not node:is_expanded() then
      state.commands.toggle_node(state)
    else
      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
    end
  end
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
      -- options go here
      window = {
        mappings = {
          ["h"]       = collapse_or_parent,
          ["<left>"]  = collapse_or_parent,
          ["l"]       = expand_or_child,
          ["<right>"] = expand_or_child,
        },
      },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
}
