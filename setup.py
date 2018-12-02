from setuptools import setup

setup(
    name='att',
    version='0.10',
    py_modules=['att'],
    author='Albert Segarra',
    url='https://github.com/albertsgrc/att-client',
    install_requires=[
        'pynput==1.4',
        'logzero==1.5.0',
        'click==6.7',
        'requests>=2.20.0',
        'gitpython==2.1.11',
        'inquirer==2.5.1',
        'validators==0.12.3',
    ],
    entry_points='''
        [console_scripts]
        att=att.att:main
   ''',
)
