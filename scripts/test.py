#!/usr/bin/env python

import sys
import datetime
import cv2
import numpy as np

def main():
    filename = sys.argv[1]
    print(f"Testing with {filename}")
    cap = cv2.VideoCapture(filename, cv2.CAP_FFMPEG)

    if cap.isOpened():
        # read first frame
        res, frame = cap.read()
        if res:
            print(frame.shape)
        else:
            print("Failed to read a frame")

        # read other frames
        num = 0
        b = datetime.datetime.now()
        while res:
            res, frame = cap.read()
            num = num + 1
        b = (datetime.datetime.now() - b).total_seconds()
        print(f"Done: {num} frames in {b} sec (fps~{num/b})")
    else:
        print("Failed to open the video")


if __name__ == "__main__":
    main()
