import os, urllib, sys, getopt

class Renamer:

    input_encoding = ""
    output_encoding = ""
    path = ""
    is_url = False

    def __init__(self, input, output, path, is_url):
        self.input_encoding = input
        self.output_encoding = output
        self.path = path
        self.is_url = is_url

    def start(self):
        self.rename_dir(self.path)

    def rename(self, root, path):
        try:
            if self.is_url:
                new = urllib.unquote(path).decode(self.input_encoding).encode(self.output_encoding)
            else:
                new = path.decode(self.input_encoding).encode(self.output_encoding)
            os.rename(os.path.join(root, path), os.path.join(root, new))
        except:
            pass

    def rename_dir(self, path):
        for root, dirs, files in os.walk(path):
            for f in files:
                self.rename(root, f)

            if dirs == []:
                for f in files:
                    self.rename(root, f)
            else:
                for d in dirs:
                    self.rename_dir(os.path.join(root, d))
                    self.rename(root, d)
def usage():
    print '''This program can change encode of files or directories.
    Usage:   rename.exe [OPTION]...
    Options:
        -h, --help                  this document.
        -i, --input-encoding=ENC    set original encoding, default is UTF-8.
        -o, --output-encoding=ENC   set output encoding, default is GBK.
        -p, --path=PATH             choose the path which to process.
        -u, --is-url                whether as a URL
    '''

def main(argv):
    input_encoding = "utf-8"
    output_encoding = "gbk"
    path = ""
    is_url = True

    try:
        opts, args = getopt.getopt(argv, "hi:o:p:u", ["help", "input-encoding=", "output-encoding=", "path=", "is-url"])
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            usage()
            sys.exit()
        elif opt in ("-i", "--input-encoding"):
            input_encoding = arg
        elif opt in ("-o", "--output-encoding"):
            output_encoding = arg
        elif opt in ("-p", "--path"):
            path = arg
        elif opt in ("-u", "--is-url"):
            is_url = True

    rn = Renamer(input_encoding, output_encoding, path, is_url)
    rn.start()

if __name__ == '__main__':
    main(sys.argv[1:])
