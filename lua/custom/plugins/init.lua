return {
  {
    'echasnovski/mini.nvim',
    version = false,
    init = function()
      require('mini.files').setup()
      vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Open floating file explorer' })
    end,
  },
  'stevearc/dressing.nvim',
  'github/copilot.vim',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      require('lualine').setup {
        theme = 'catppuccin',
        extensions = { 'lazy', 'fugitive', 'trouble', 'symbols-outline' },
      }
    end,
  },
  {
    'skonky/prodge.nvim',
    dir = '/Users/skonky/plugins/prodge.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'akinsho/toggleterm.nvim',
    },
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    config = function()
      local function prettierd_or_prettier()
        local has_prettierd = vim.fn.executable 'prettierd' == 1
        if has_prettierd then
          return { 'prettierd' } -- Found prettierd
        else
          return { 'prettier' } -- Fallback to prettier
        end
      end

      local opts = {
        notify_on_error = false,
        format_on_save = {
          timeout_ms = 250,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = prettierd_or_prettier(),
          typescript = prettierd_or_prettier(),
          typescriptreact = prettierd_or_prettier(),
        },
      }
      require('conform').setup(opts)
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, direction = 'float' }

      function _lazygit_toggle()
        lazygit:toggle()
      end

      require('toggleterm').setup()

      vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>t', '<cmd>ToggleTerm<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>gt', '<cmd>TermExec cmd="gleam test"<CR>', { noremap = true, silent = true })
    end,
  },
  'nvimtools/none-ls-extras.nvim',
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
    },
    config = function()
      local null_ls = require 'null-ls'
      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        sources = {
          require('none-ls.code_actions.eslint').with {
            name = 'eslint',
            filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
            command = 'eslint',
          },
        },
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
  },
}
