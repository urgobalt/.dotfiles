return {
  { "ThePrimeagen/git-worktree.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    enabled = true,
    opts = {
      config = function()
        require("telescope").load_extension("git-worktree")
      end,
    },
  },
}
