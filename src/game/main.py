import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def main() -> None:
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    qml_file_path = Path(__file__).parent / "main.qml"
    engine.load(qml_file_path)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
