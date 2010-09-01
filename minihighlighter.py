import codecs
import os
import sys

from pygments import highlight
from pygments.lexers import CLexer, guess_lexer_for_filename
from pygments.formatter import Formatter
from pygments.styles import get_style_by_name
from pygments.token import Token

from PIL import Image, ImageColor

TAB_SIZE = 4

def readFileContents(fn):
    fileHandle = codecs.open(fn, encoding='utf-8')
    fileContents = unicode(fileHandle.read())
    fileHandle.close()
    return fileContents

class MiniFormatter(Formatter):
    def __init__(self, code):
        super(MiniFormatter, self).__init__()

        self.canvas = Canvas(code)
        self.code = code

    def format(self, tokensource, outfile):
        x = y = 0
        colors = {}

        for (ttype, d) in get_style_by_name('default'):
            if d["color"]:
                color = "#" + d["color"]
            elif d["italic"]:
                color = "#991212"
            elif d["bold"]:
                color = "#129912"
            else:
                color = "#cccccc"

            colors[ttype] = ImageColor.getrgb(color)

        for (ttype, value) in tokensource:
            for char in value:
                if not char.isspace() or (ttype in Token.Comment):
                    self.canvas.image.putpixel((x, y), colors[ttype])

                if char == '\t':
                    x += TAB_SIZE
                elif char == '\n':
                    x = 0
                    y += 1
                else:
                    x += 1

def getPixelSizeForString(code):
    lines = code.splitlines()

    width = 0
    height = 0

    for line in lines:
        height += 1
        lineWidth = 0

        for char in line:
            if char == '\t':
                lineWidth += TAB_SIZE
            else:
                lineWidth += 1

        if lineWidth > width:
            width = lineWidth

    return (width, height)

class Canvas(object):
    def __init__(self, code):
        super(Canvas, self).__init__()

        self.width, self.height = getPixelSizeForString(code)
        self.code = code
        self.image = Image.new("RGB", (self.width, self.height), (255, 255, 255))

def main():
    if len(sys.argv) != 2:
        print "Usage:\n\n    {0} FILENAME".format(sys.argv[0])
        exit(1)

    filename = sys.argv[1]

    try:
        code = readFileContents(filename)
    except:
        print "Failed to load {0}.".format(filename)
        exit(2)

    form = MiniFormatter(code)
    highlight(code, guess_lexer_for_filename(filename, code), form)
    form.canvas.image.save(os.path.splitext(filename)[0] + ".png")

if __name__ == "__main__":
    main()