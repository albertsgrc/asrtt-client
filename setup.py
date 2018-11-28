from setuptools import setup

setup(
    name='att',
    version='0.10',
    py_modules=['att', 'clockify'],
    author='Albert Segarra',
    url='https://github.com/albertsgrc/att-client',
    install_requires=[
        'pyinput',
        'logzero',
        'click==6.7',
        'certifi==2018.8.13',
        'chardet==3.0.4',
        'click==6.7',
        'idna==2.7',
        'requests>=2.20.0',
        'urllib3==1.23',
    ],
    entry_points='''
        [console_scripts]
        att=att.att:main
   ''', 
)
