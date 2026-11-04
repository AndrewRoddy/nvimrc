" Vim filetype detection for ASP.NET Core Razor components.
" Not setf: files like App.razor start with <!DOCTYPE html> and would stay html.
au BufRead,BufNewFile *.razor set filetype=razor
