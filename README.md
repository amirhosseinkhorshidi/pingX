سرویس `pingx` که یک IP مشخص را به صورت متناوب پینگ می‌کند و در صورت عدم موفقیت، یک سرویس خاص را مجدداً راه‌اندازی می‌کند.

## مراحل ایجاد اسکریپت پینگ

**ایجاد پوشه و فایل اسکریپت**

   ```bash
   mkdir /root/px
   nano /root/px/pingx.sh
   ```

**اضافه کردن محتوای اسکریپت**

   محتوای زیر را در فایل `pingx.sh` قرار دهید:

   ```bash
   #!/bin/bash

   IP="1.1.1.1" #ایپی شما
   COMMAND="sudo systemctl restart pingx.service" #دستور شما
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

**اعطای مجوزهای اجرایی به اسکریپت**

   ```bash
   sudo chmod +x /root/px/pingx.sh
   ```

## ایجاد و راه‌اندازی سرویس systemd

**ایجاد فایل واحد سرویس**

   ```bash
   sudo nano /etc/systemd/system/pingx.service
   ```

**اضافه کردن محتوای زیر به فایل سرویس**

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

**بارگذاری مجدد تنظیمات systemd**

   ```bash
   sudo systemctl daemon-reload
   ```

**فعال‌سازی سرویس برای اجرای خودکار در زمان بوت**

   ```bash
   sudo systemctl enable pingx.service
   ```

**شروع سرویس**

   ```bash
   sudo systemctl start pingx.service
   ```

## مدیریت سرویس

**توقف سرویس**

  ```bash
  sudo systemctl stop pingx.service
  ```

**راه‌اندازی مجدد سرویس (برای اعمال تغییرات)**

  ```bash
  sudo systemctl restart pingx.service
  ```

## بررسی وضعیت سرویس

برای بررسی وضعیت فعلی سرویس و مشاهده جزئیات، از دستور زیر استفاده کنید:

```bash
sudo systemctl status pingx.service
```
