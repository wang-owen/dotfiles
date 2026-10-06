return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠼⠟⠛⠛⠣⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⢠⡿⠋⠃⠀⠀⠀⠀⠀⠀⠘⠟⢄⡀⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⢀⡼⡟⣯⡿⠛⠛⠿⠕⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠺⣃⠀⠀⠀⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⣀⠰⠟⠛⠻⠿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠶⠶⢆⣀⠀⠀⠀]],
      [[⠀⠀⣠⡾⠉⠀⠀⠀⠀⠀⠑⠃⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠈⢻⡷⣀⠀]],
      [[⢀⣼⠇⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆]],
      [[⢸⡇⠀⠈⢀⠀⠀⠀⠀⠀⠀⠀⡆⢀⠀⠀⠀⠀⠀⠜⠀⠀⠀⠀⠀⠀⠀⠴⡀⠀⠀⠰⠀⢸⡇]],
      [[⠀⢱⣆⠀⠈⠓⠒⠒⠚⢅⣶⡊⠀⠈⠸⡉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠆⠈⠀⠀⠀⣾⠁]],
      [[⠀⠀⠛⢗⣐⣠⣤⣐⣾⣿⣿⣷⣀⡄⢀⡠⢡⣶⣶⣶⡀⠀⠀⠀⠀⠀⡰⢧⣀⣼⣶⣾⠟⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠉⢿⡼⠿⢿⣿⡿⠋⠉⠉⠉⠸⣿⠯⣿⣶⣶⣶⣿⡿⠏⠉⠉⠁⠀⠀⠀⠀]],
      [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠋⠉⠀⠀⠀⠀⠀⠀⠀⠋⠻⠿⠿⠏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('b', '\u{f002}  >  Browse Files', ':Yazi<CR>'),
      dashboard.button('d', '\u{f0968}  >  Browse Directories', ':lua Snacks.picker.zoxide()<CR>'),
      dashboard.button('f', '\u{f0c7c}  >  Find File', ':lua Snacks.picker.files()<CR>'),
      dashboard.button('r', '\u{f017}  >  Recent', ':lua Snacks.picker.recent()<CR>'),
    }

    alpha.setup(dashboard.config)
  end,
}
