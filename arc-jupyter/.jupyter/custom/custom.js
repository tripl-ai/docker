// add code format for arc types
require(['notebook/js/codecell'], function (codecell) {
  codecell.CodeCell.options_default.highlight_modes['magic_text/x-sh'] = { 'reg': [/^%env|^%metadata|^%conf|^%list/] };
  codecell.CodeCell.options_default.highlight_modes['magic_text/x-sql'] = { 'reg': [/^%sql|^%log/] };
  codecell.CodeCell.options_default.highlight_modes['magic_application/x-cypher-query'] = { 'reg': [/^%cypher/] };
  codecell.CodeCell.options_default.highlight_modes['magic_text/javascript'] = { 'reg': [/^%arc|^%configplugin|^%lifecycleplugin|^{/] };

  // auto highlight on start
  if (Jupyter.hasOwnProperty['notebooks'] && Jupyter.notebooks.hasOwnProperty['events']) {
    Jupyter.notebook.events.on('kernel_ready.Kernel', function () {
      Jupyter.notebook.get_cells().map(function (cell) {
        if (cell.cell_type == 'code') { cell.auto_highlight(); }
      });
    });
  };
});

