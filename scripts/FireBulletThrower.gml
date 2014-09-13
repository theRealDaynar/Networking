        var inacArc = random(inaccuracyArc * 4) - inaccuracyArc*2;
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
        instProj.direction = aimAngle + inacArc + aimMode
        instProj.owner = id
        SendBullet(instProj)
        rofcd = ceil(room_speed/30)
