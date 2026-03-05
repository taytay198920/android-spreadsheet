# 使用官方Flutter Docker镜像
FROM cirrusci/flutter:stable

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 安装依赖
RUN flutter pub get

# 构建APK
RUN flutter build apk --release

# 输出APK文件
VOLUME ["/app/build/app/outputs/flutter-apk"]