-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Remap function
local function map(mode, keys, command)
  return vim.api.nvim_set_keymap(mode, keys, command, { noremap = true, silent = true })
end

-- General
lvim.leader = "space"
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "lunar"


-- Line numbers
vim.opt.number = false
vim.opt.relativenumber = false

-- lvim.lsp.diagnostics.virtual_text = false
-- lvim.use_icons = false -- to disable icons and use a minimalist setup, uncomment the following

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"


lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.bufferline.active = false -- tabs
lvim.builtin.lualine.options.globalstatus = true
lvim.builtin.lualine.sections.lualine_c = {
  {
    "filename",
    path = 1,
    symbols = {
      modified = " ", -- Text to show when the file is modified.
      readonly = " ", -- Text to show when the file is non-modifiable or readonly.
      unnamed = "[No Name]", -- Text to show for unnamed buffers.
      newfile = "[New]", -- Text to show for new created file before first writting
    },
  },
}
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.terminal.active = true
lvim.builtin.treesitter.active = false
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "python",
  "rust",
  "tsx",
  "typescript",
  "yaml",
}
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.ignore_install = { "haskell" }

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", args = { "--profile", "black" }, filetypes = { "python" } },
  --   {
  --     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  --     command = "prettier",
  --     ---@usage arguments to pass to the formatter
  --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
  --     extra_args = { "--print-with", "100" },
  --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --     filetypes = { "typescript", "typescriptreact" },
  --   },
}

-------------------------------------------------------------------------------------------
-- Additional Plugins
lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },
  { "tpope/vim-unimpaired" },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
  {
  "cuducos/yaml.nvim",
  ft = { "yaml" }, -- optional
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
  },
}
}

-- ------------------------------- Vim Surround --------------------------------------
vim.cmd [[
    " https://github.com/tpope/vim-surround/issues/269
    " Disable the default mappings (s, ys, S etc)
    let g:surround_no_mappings=1

    nmap ds  <Plug>Dsurround
    nmap cs  <Plug>Csurround
    nmap cS  <Plug>CSurround
    nmap s   <Plug>Ysurround
    nmap yS  <Plug>YSurround
    nmap ss  <Plug>Yssurround
    nmap ySs <Plug>YSsurround
    nmap ySS <Plug>YSsurround
    xmap s   <Plug>VSurround
    xmap gS  <Plug>VgSurround

    if !exists("g:surround_no_insert_mappings") || ! g:surround_no_insert_mappings
      if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
        imap    <C-S> <Plug>Isurround
      endif
      imap      <C-G>s <Plug>Isurround
      imap      <C-G>S <Plug>ISurround
    endif
  ]]


---------------------------------------------
-- Custom Mappings
map("n", "Q", "@q")
map("v", "Q", [[:norm @q<cr>]])
map("n", "<space>ss", ":Telescope current_buffer_fuzzy_find<cr>")
map("n", "<space>pv", ":Ex<cr>")
map("n", "<space>y", "gg0vG$$y")                                      -- Yank entire file
map("n", "<space>rs", [[<cmd>lua require("persistence").load()<cr>]]) -- restore the session for the current directory
map("n", "<space>,", ":Telescope buffers<cr>")                        -- buffers
map("n", "]e", ":lua vim.diagnostic.goto_next()<cr>")                 -- next error
map("n", "[e", ":lua vim.diagnostic.goto_prev()<cr>")                 -- previous error
