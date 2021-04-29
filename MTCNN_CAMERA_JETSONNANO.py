import cv2
from mtcnn import MTCNN


def gstreamer_pipeline(
    capture_width=640,
    capture_height=360,
    display_width=640,
    display_height=360,
    framerate=60,
    flip_method=0,
):
    return (
        "nvarguscamerasrc ! "
        "video/x-raw(memory:NVMM), "
        "width=(int)%d, height=(int)%d, "
        "format=(string)NV12, framerate=(fraction)%d/1 ! "
        "nvvidconv flip-method=%d ! "
        "video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! "
        "videoconvert ! "
        "video/x-raw, format=(string)BGR ! appsink"
        % (
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height,
        )
    )

def drawMtcnnRes( Inimg , detections):
    min_conf = 0.3
    for det in detections:
        if det['confidence'] >= min_conf:
            x, y, width, height = det['box']
            keypoints = det['keypoints']
            cv2.rectangle(Inimg, (x,y), (x+width,y+height), (0,155,255), 2)
            cv2.circle(Inimg, (keypoints['left_eye']), 2, (0,155,255), 2)
            cv2.circle(Inimg, (keypoints['right_eye']), 2, (0,155,255), 2)
            cv2.circle(Inimg, (keypoints['nose']), 2, (0,155,255), 2)
            cv2.circle(Inimg, (keypoints['mouth_left']), 2, (0,155,255), 2)
            cv2.circle(Inimg, (keypoints['mouth_right']), 2, (0,155,255), 2)
            
        
def show_camera():
    detector = MTCNN()
    print(gstreamer_pipeline(flip_method=2))
    cap = cv2.VideoCapture(gstreamer_pipeline(flip_method=2), cv2.CAP_GSTREAMER)
    if cap.isOpened():
        window_handle = cv2.namedWindow("CSI Camera", cv2.WINDOW_AUTOSIZE)
        # Window
        while cv2.getWindowProperty("CSI Camera", 0) >= 0:
            ret_val, cvimg = cap.read()
            imgRGB = cv2.cvtColor(cvimg, cv2.COLOR_BGR2RGB)
            DetRes = detector.detect_faces(imgRGB)
            drawMtcnnRes(cvimg , DetRes)
            cv2.imshow("CSI Camera", cvimg)
            # This also acts as
            keyCode = cv2.waitKey(30) & 0xFF
            # Stop the program on the ESC key
            if keyCode == 27:
                break
        cap.release()
        cv2.destroyAllWindows()
    else:
        print("Unable to open camera")


if __name__ == "__main__":
    
    show_camera()






    

