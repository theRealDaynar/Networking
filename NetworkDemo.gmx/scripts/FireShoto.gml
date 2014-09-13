var spreadDir = bulletArc/2.5
repeat(bulletNum)
{
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
        instProj.direction = aimAngle + aimMode + spreadDir
        instProj.owner = id
        SendBullet(instProj)
        spreadDir -= bulletArc/bulletNum   
}
rofcd = ceil(room_speed/2)
