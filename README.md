در اینجا یک فایل README.md برای مراحل ایجاد و راه‌اندازی سرویس `pingx` آورده شده است:

```markdown
# Ping Check Service

این راهنما شما را در مراحل ایجاد و راه‌اندازی سرویس `pingx` که یک IP مشخص را به صورت متناوب پینگ می‌کند و در صورت عدم موفقیت، یک سرویس خاص را مجدداً راه‌اندازی می‌کند، همراهی می‌کند.

## مراحل ایجاد اسکریپت پینگ

1. **ایجاد پوشه و فایل اسکریپت**

   ```bash
   mkdir /root/px
   nano /root/px/pingx.sh
   ```

2. **اضافه کردن محتوای اسکریپت**

   محتوای زیر را در فایل `pingx.sh` قرار دهید:

   ```bash
   #!/bin/bash

   IP="1.1.1.1"
   COMMAND="sudo systemctl restart easymesh.service"
   PING_COUNT=4
   LOG_FILE="/var/log/ping_check.log"

   echo "Ping check started at $(date)" >> $LOG_FILE

   while true; do
     PING_RESULT=$(ping -c $PING_COUNT $IP)
     if [ $? -eq 0 ]; then
       echo "$(date): Ping successful to $IP" >> $LOG_FILE
       echo "$PING_RESULT" >> $LOG_FILE
     else
       echo "$(date): Ping failed to $IP" >> $LOG_FILE
       COMMAND_OUTPUT=$($COMMAND 2>&1)
       echo "$(date): Command executed: $COMMAND" >> $LOG_FILE
       echo "$(date): Command output: $COMMAND_OUTPUT" >> $LOG_FILE
     fi
     sleep 60
   done
   ```

3. **اعطای مجوزهای اجرایی به اسکریپت**

   ```bash
   sudo chmod +x /root/px/pingx.sh
   ```

## ایجاد و راه‌اندازی سرویس systemd

1. **ایجاد فایل واحد سرویس**

   ```bash
   sudo nano /etc/systemd/system/pingx.service
   ```

2. **اضافه کردن محتوای زیر به فایل سرویس**

   ```ini
   [Unit]
   Description=Ping Check Service
   After=network.target

   [Service]
   ExecStart=/bin/bash /root/px/pingx.sh
   Restart=always
   User=root

   [Install]
   WantedBy=multi-user.target
   ```

3. **بارگذاری مجدد تنظیمات systemd**

   ```bash
   sudo systemctl daemon-reload
   ```

4. **فعال‌سازی سرویس برای اجرای خودکار در زمان بوت**

   ```bash
   sudo systemctl enable pingx.service
   ```

5. **شروع سرویس**

   ```bash
   sudo systemctl start pingx.service
   ```

## مدیریت سرویس

- **توقف سرویس**

  ```bash
  sudo systemctl stop pingx.service
  ```

- **راه‌اندازی مجدد سرویس (برای اعمال تغییرات)**

  ```bash
  sudo systemctl restart pingx.service
  ```

## بررسی وضعیت سرویس

برای بررسی وضعیت فعلی سرویس و مشاهده جزئیات، از دستور زیر استفاده کنید:

```bash
sudo systemctl status pingx.service
```

این دستورات و مراحل به شما کمک می‌کنند تا سرویس `pingx` را به درستی ایجاد و مدیریت کنید.
```

این فایل README.md تمامی مراحل لازم برای ایجاد، پیکربندی و مدیریت سرویس `pingx` را شامل می‌شود. امیدوارم این راهنما برای شما مفید باشد.
