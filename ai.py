import cv2
import mediapipe as mp
import numpy as np  # Add this line to import NumPy
import time

# Function to detect hand gestures and record finger count
def detect_gesture(frame, hands):
    finger_count = 0  # Initialize finger count
    if hands.multi_hand_landmarks:
        for hand_landmarks in hands.multi_hand_landmarks:
            # Get landmarks of the hand
            landmarks = []
            for lm in hand_landmarks.landmark:
                # Normalize landmarks to frame dimensions
                h, w, _ = frame.shape
                x, y = int(lm.x * w), int(lm.y * h)
                landmarks.append((x, y))

            # Calculate distance between thumb and other fingers
            thumb_tip = landmarks[4]
            index_tip = landmarks[8]
            middle_tip = landmarks[12]
            ring_tip = landmarks[16]
            pinky_tip = landmarks[20]

            # Calculate distances between thumb and other fingers
            thumb_index_distance = cv2.norm(np.array(thumb_tip) - np.array(index_tip))
            thumb_middle_distance = cv2.norm(np.array(thumb_tip) - np.array(middle_tip))
            thumb_ring_distance = cv2.norm(np.array(thumb_tip) - np.array(ring_tip))
            thumb_pinky_distance = cv2.norm(np.array(thumb_tip) - np.array(pinky_tip))

            # Finger count based on distances
            if thumb_index_distance > 100:
                finger_count += 1
            if thumb_middle_distance > 100:
                finger_count += 1
            if thumb_ring_distance > 100:
                finger_count += 1
            if thumb_pinky_distance > 100:
                finger_count += 1

            # Save finger count to file
            with open("finger_count.txt", "w") as f:
                f.write(str(finger_count))

            # Display finger count
            cv2.putText(frame, f"Finger Count: {finger_count}", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)

            # Draw hand landmarks
            mp.solutions.drawing_utils.draw_landmarks(frame, hand_landmarks, mp.solutions.hands.HAND_CONNECTIONS)

    return frame

# Main function
def main():
    # Initialize MediaPipe Hands model
    mp_hands = mp.solutions.hands.Hands()

    # Open the webcam
    cap = cv2.VideoCapture(0)
    
    start_time = time.time()  # Record start time
    while time.time() - start_time < 12:  # Continue loop for 8 seconds
        # Read a frame from the webcam
        ret, frame = cap.read()

        if not ret:
            break

        # Flip the frame horizontally for a mirror-like effect
        frame = cv2.flip(frame, 1)

        # Convert BGR image to RGB
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # Detect hands in the frame
        results = mp_hands.process(rgb_frame)

        # Detect hand gestures and save finger count to file
        frame = detect_gesture(frame, results)

        # Display the frame
        cv2.imshow('Hand Gesture Detection', frame)

        # Exit the loop when 'q' is pressed
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    
    # Release the webcam and close all windows
    cap.release()
    cv2.destroyAllWindows()
    # Close MediaPipe hands model
    mp_hands.close()

if __name__ == "__main__":
    main()
