# OTP Catcher: Automatic SMS Code

**Short Description:** OTP Catcher is a background application that monitors incoming messages, automatically extracts codes (e.g., verification codes, one-time passwords), displays a notification when a code is found, and copies the code to your clipboard for easy pasting.

## Features

*   **Background Monitoring:** Runs silently in the background, constantly watching for new messages. Uses very little resources
*   **Code Detection:** Code detection is done by Apple for notification in Safari. This just hijacked the same detection..
*   **Notification Alerts:** Displays a notification when a code is detected, ensuring you don't miss it.
*   **Clipboard Copy:** Automatically copies the extracted code to your clipboard, ready to be pasted into any input field.


## Building the Application

This section outlines the general steps required to build OTP Catcher. Specific instructions may vary depending on your chosen development environment and target platform (e.g., Android, iOS, desktop).

**Prerequisites:**

**Granting Full Disk Access:**

1.  Open **System Settings**.
2.  Go to **Privacy & Security**.
3.  Scroll down to **Full Disk Access**.
4.  Click the **+** button.
5.  Select the **OTP Catcher** application from your Applications folder.
6.  Ensure that the checkbox next to **OTP Catcher** is checked.
7. You may need to restart the app for the changes to take effect.


## Potential Improvements

*   **Customizable Code Patterns:** Allow users to define custom patterns for code detection.
*   **Code History:** Maintain a history of extracted codes for easy reference.
*   **Security:** Implement security measures to protect sensitive information.


## Contributing

If you'd like to contribute to the development of OTP Catcher, please feel free to fork the repository and submit pull requests.

## License

[GPL License]
