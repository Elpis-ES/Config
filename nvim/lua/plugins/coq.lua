return {
  {
    "ms-jpq/coq_nvim",
    branch = "coq",
    lazy = false,
  },
  {
    "ms-jpq/coq.artifacts",
    branch = "artifacts",
    lazy = false,
  },
  {
    "ms-jpq/coq.thirdparty",
    branch = "3p",
    lazy = false,
    config = function()
      require("coq_3p")({
        { src = "bc", short_name = "MATH", precision = 6 },
      })
    end,
  },
}
