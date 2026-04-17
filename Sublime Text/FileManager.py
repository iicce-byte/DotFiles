import sublime
import sublime_plugin
import os
import functools

# --- 命令 1：重命名当前文件 ---
class RenameCurrentFileCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        filename = self.view.file_name()
        if not filename:
            return
        
        # 在底部弹出输入框，默认填入当前文件名
        branch, leaf = os.path.split(filename)
        v = self.view.window().show_input_panel(
            "New Name:", leaf, 
            functools.partial(self.on_done, filename, branch), 
            None, None
        )
        # 选中文件名部分（方便直接修改）
        name, ext = os.path.splitext(leaf)
        v.sel().clear()
        v.sel().add(sublime.Region(0, len(name)))

    def on_done(self, old_path, branch, new_name):
        new_path = os.path.join(branch, new_name)
        try:
            os.rename(old_path, new_path)
            # 重命名后重新打开文件，保证 Tab 依然有效
            self.view.window().find_open_file(old_path).retarget(new_path)
            sublime.status_message("Renamed to: " + new_name)
        except OSError as e:
            sublime.error_message("Error renaming: " + str(e))

# --- 命令 2：删除当前文件 ---
class DeleteCurrentFileCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        filename = self.view.file_name()
        if not filename:
            return
        
        # 弹出确认框，防止手滑
        if sublime.ok_cancel_dialog(f"Delete this file?\n\n{filename}", "Delete"):
            try:
                os.remove(filename) # 彻底删除（不进回收站）
                # 如果你想进回收站，可以用 send2trash 库，但这里为了原生简单直接用 remove
                self.view.close()   # 关闭当前 Tab
                sublime.status_message("Deleted: " + filename)
            except OSError as e:
                sublime.error_message("Error deleting: " + str(e))

# --- 命令 3：在当前目录下创建新文件 (类似 AdvancedNewFile 的简化版) ---
class CreateFileInCurrentDirCommand(sublime_plugin.WindowCommand):
    def run(self):
        if not self.window.active_view():
            return
        filename = self.window.active_view().file_name()
        if filename:
            base_dir = os.path.dirname(filename)
        else:
            # 如果当前是空 Tab，就尝试获取项目根目录，或者默认为 Home
            folders = self.window.folders()
            base_dir = folders[0] if folders else os.path.expanduser("~")

        self.window.show_input_panel(
            "New File Name:", "", 
            functools.partial(self.on_done, base_dir), 
            None, None
        )
    
    def on_done(self, base_dir, user_input):
        full_path = os.path.join(base_dir, user_input)
        # 自动创建文件夹（如果输入路径包含斜杠）
        target_dir = os.path.dirname(full_path)
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)
        
        # 创建并打开文件
        with open(full_path, 'a'):
            os.utime(full_path, None)
        self.window.open_file(full_path)

# --- 命令 4：在当前目录创建文件夹 ---
class CreateFolderInCurrentDirCommand(sublime_plugin.WindowCommand):
    def run(self):
        view = self.window.active_view()
        if not view:
            return

        filename = view.file_name()
        if filename:
            base_dir = os.path.dirname(filename)
        else:
            # 当前如果是空白页面或没有文件，使用项目根目录或 home
            folders = self.window.folders()
            base_dir = folders[0] if folders else os.path.expanduser("~")

        # 输入框：让用户输入文件夹名称
        self.window.show_input_panel(
            "New Folder Name:", "",
            functools.partial(self.on_done, base_dir),
            None, None
        )

    def on_done(self, base_dir, folder_name):
        new_folder_path = os.path.join(base_dir, folder_name)

        try:
            if not os.path.exists(new_folder_path):
                os.makedirs(new_folder_path)
                sublime.status_message("Created folder: " + new_folder_path)
            else:
                sublime.status_message("Folder already exists: " + new_folder_path)
        except OSError as e:
            sublime.error_message("Error creating folder: " + str(e))
