# imports
import os
import cv2
#from PIL import Image

folder = r'G:\Film\Complete\2 Anal 4 U (2002)'
file = '2 Anal 4 U (2002).mkv'

screenshot_folder = os.path.join(folder, 'Screenshots')
if not os.path.exists(screenshot_folder):
    os.makedirs(screenshot_folder)

step = 180  # step every 5 minutes (300 secs)
frames_count = 100  # number of screenshots

currentframe = 0
frames_captured = 0

cam = cv2.VideoCapture(os.path.join(folder, file))  # open file

frame_per_second = cam.get(cv2.CAP_PROP_FPS)  # get reading num frames at partcular second

while True:
    ret, frame = cam.read()
    if ret:
        if currentframe > (step * frame_per_second):
            currentframe = 0

            # saving the frames (screenshots)
            file_name = '{}'.format(str(frames_captured) + '.jpg')
            print('Creating...' + file_name)

            cv2.imwrite(os.path.join(screenshot_folder, file_name), frame)
            frames_captured += 1

            # breaking the loop when count achieved
            if frames_captured > frames_count - 1:
                ret = False
        currentframe += 1
    if ret == False:
        break

# Releasing all space and windows once done
cam.release()
cv2.destroyAllWindows()