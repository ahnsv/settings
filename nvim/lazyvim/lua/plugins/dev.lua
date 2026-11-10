return {
  {
    dir = "/Users/taeahn/devs/personal/2026/markdown-viewer/apps/neovim",
    name = "markdown-viewer.nvim",
    cmd = { "MkvrSetUp", "MkvrOpen" },
    config = function()
      require("mkvr").setup({
        desktop_dev = true,
        desktop_dev_root = "/Users/taeahn/devs/personal/2026/markdown-viewer/apps/desktop-tauri",
      })
    end,
  },
}
