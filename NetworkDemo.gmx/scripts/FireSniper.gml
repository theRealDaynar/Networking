        var aimMode = 0
        if image_xscale=1
        {
            var instProj = instance_create(x + lengthdir_x(24.1868, aimAngle+7.12502),y + 23 + lengthdir_y(24.1868, aimAngle+7.12502),oServerProjectile);
        }
        else
        {
            var instProj = instance_create(x - lengthdir_x(24.1868, aimAngle-7.12502),y + 23 - lengthdir_y(24.1868, aimAngle-7.12502),oServerProjectile);
            aimMode=180
        }
        instProj.speed = bulletSpd
        instProj.direction = aimAngle + aimMode
        instProj.owner = id
        SendBullet(instProj)
        if bulletStringN<bulletString
        {
            rofcd = ceil(room_speed/30)
            bulletStringN++
        }
        else
        {
            bulletStringN=0
            rofcd = room_speed
        }
        
