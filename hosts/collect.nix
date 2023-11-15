let
  inputFile = ./email.txt;  # 文件路径

  # 读取文件内容并根据 "@" 进行分割
  splitEmail = email: builtins.split "@" email;

  # 从文件读取字符串并处理
  emailContents = builtins.readFile inputFile;
  [user domain] = splitEmail emailContents;
in
{
  user = user;
  domain = domain;
}
