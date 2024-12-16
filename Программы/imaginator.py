#!/usr/bin/env python3

from PIL import Image
import os
import tkinter as tk
from tkinter import filedialog


# Интерфейс
root = tk.Tk()
root.title("Imaginator")
root.geometry("400x600")
root.grid_rowconfigure(0, weight=1)
root.grid_columnconfigure(0, weight=1)
root.option_add("*Listbox.Font", "times 20")
scrollbar = tk.Scrollbar(root, orient="vertical")
lb = tk.Listbox(root, width=50, height=20, yscrollcommand=scrollbar.set)
scrollbar.config(command=lb.yview)

scrollbar.grid(row=0, column=1, sticky="ns")
lb.grid(row=0, column=0, sticky="nsew")

frame = tk.Frame(root)
frame.grid(row=1,column=0)

# Функции для кнопок
def delete():
    for item in lb.curselection():
        lb.delete(item)
        lb.select_set(0)

def upp():
    for item in lb.curselection():
        if item != 0:
            element = lb.get(item)
            lb.delete(item)
            lb.insert(item-1, element)
            lb.select_set(item-1)      
            
def down():
    for item in lb.curselection():
        if item < lb.size() - 1:
            element = lb.get(item)
            lb.delete(item)
            lb.insert(item+1, element)
            lb.select_set(item+1)

def show():
    for item in lb.curselection():
        element = lb.get(item)
        full_filename = os.path.join(curr_path, element)
        Image.open(full_filename).show()

def save():
    imgs = []
    files = lb.get(0, tk.END)
    for file in files:
        full_filename = os.path.join(curr_path, file)
        imgs.append(Image.open(full_filename))    
    width = 0
    height = 0
    for img in imgs:
        if img.size[0] > width:
            width = img.size[0]
        height += img.size[1]    
    img = Image.new('RGB', (width, height), color='white')
    curr_y = 0
    for i in range(len(imgs)):
        img.paste(imgs[i], (0, curr_y))
        curr_y += imgs[i].size[1]
    outputfilename = os.path.join(curr_path, "out.jpg")
    img.save(outputfilename, 'JPEG')

def open_dir(path='.'):
    imgs = os.listdir(path)
    for img in imgs:
        if ('.jpg' in img):
            lb.insert(tk.END, img)

def open():
    dir = filedialog.askdirectory()
    if dir:  
        global curr_path     
        curr_path=dir
        lb.delete(0, tk.END)
        open_dir(dir)        

def append():
    file = filedialog.askopenfile(filetypes=[
                    ("image", ".jpeg"),
                    ("image", ".png"),
                    ("image", ".jpg")])
    if file:
        file = os.path.basename(file.name)        
        lb.insert(tk.END, file)  


button_del = tk.Button(frame, text='Удалить', height=3, width=9, command=delete)
button_del.grid(row=0,column=0)

button_up = tk.Button(frame, text='Вверх', height=3, width=9, command=upp)
button_up.grid(row=0,column=1)

button_down = tk.Button(frame, text='Вниз', height=3, width=9, command=down)
button_down.grid(row=0,column=3)

button_show = tk.Button(frame, text='Показать', height=3, width=9, command=show)
button_show.grid(row=0,column=4)

frame_bottom = tk.Frame(root)
frame_bottom.grid(row=2,column=0)

button_add = tk.Button(frame_bottom, text='Добавить файл', height=3, width=12, command=append)
button_add.grid(row=0,column=0)

button_open = tk.Button(frame_bottom, text='Открыть папку', height=3, width=12, command=open)
button_open.grid(row=0,column=1)

button_save = tk.Button(frame_bottom, text='Сохранить', height=3, width=12, command=save)
button_save.grid(row=0,column=2)

open()
root.mainloop()

