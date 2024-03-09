return {
  -- add themes via github
  { "projekt0n/github-nvim-theme" },

  -- Configure LazyVim to load the themes
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_high_contrast",
    },
  },
}
