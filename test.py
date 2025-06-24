import time
import threading
from pynput import keyboard, mouse
from pynput.keyboard import Controller as KeyboardController
from pynput.mouse import Controller as MouseController
import win32api
import win32con

def move_mouse_relative(x, y):
    win32api.mouse_event(win32con.MOUSEEVENTF_MOVE, x, y, 0, 0)

# Settings
strafe_delay = 0.1         # Delay between A/D switches (slower)
mouse_move_amount = 2000     # Pixels to move mouse left/right
strafe_key = 'e'           # Toggle key

# Controllers and state
keyboard_controller = KeyboardController()
mouse_controller = MouseController()
strafing_enabled = False

def strafe_loop():
    global strafing_enabled
    direction = True  # True = 'a', False = 'd'
    while True:
        if strafing_enabled:
            if direction:
                keyboard_controller.press('a')
                time.sleep(0.05)
                keyboard_controller.release('a')
                move_mouse_relative(-mouse_move_amount, 0)  # Move mouse left
            else:
                keyboard_controller.press('d')
                time.sleep(0.05)
                keyboard_controller.release('d')
                move_mouse_relative(mouse_move_amount, 0)  # Move mouse right

            direction = not direction
            time.sleep(strafe_delay)
        else:
            time.sleep(0.1)

def on_press(key):
    global strafing_enabled
    try:
        if key.char == strafe_key:
            strafing_enabled = not strafing_enabled
            print(f"[INFO] Strafing {'enabled' if strafing_enabled else 'disabled'}")
    except AttributeError:
        pass

# Start strafing thread
threading.Thread(target=strafe_loop, daemon=True).start()

# Start key listener
print(f"Press '{strafe_key.upper()}' to toggle auto-strafing.")
with keyboard.Listener(on_press=on_press) as listener:
    listener.join()
