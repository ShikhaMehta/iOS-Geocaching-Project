import os.path


class FileHelper:
    filepath = ""

    def __init__(self, filepath):
        self.filepath = filepath

    def get(self):
        with open(self.filepath, 'r') as f:
            return f

    def read(self):
        try:
            with open(os.path.dirname(__file__) + self.filepath, 'r') as f:
                contents = f.read()
                f.close()
                return contents
        except EnvironmentError:
            return ""

    def write(self, string):
        try:
            with open(os.path.dirname(__file__) + self.filepath, 'w') as f:
                f.seek(0)
                f.truncate()
                f.write(str(string))
                f.close()
                return True
        except EnvironmentError:
            return False

    def erase(self):
        try:
            with open(os.path.dirname(__file__) + self.filepath, 'w') as f:
                f.seek(0)
                f.truncate()
                f.close()
                return True
        except EnvironmentError:
            return False

    def replace_contents(self, newcontents):
        if self.erase():
            if self.write(newcontents):
                return True
        return False

    def empty(self):
        try:
            with open(os.path.dirname(__file__) + self.filepath, 'r') as f:
                contents = f.read()
                f.close()
                if contents == '':
                    return True
                return False
        except EnvironmentError:
            return False
