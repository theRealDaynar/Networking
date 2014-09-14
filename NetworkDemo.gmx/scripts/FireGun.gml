if chargeUpTime<=chargeUp
{
    if client=false
        var o = oServerProjectile
    else
        var o = oClientProjectile
    shooting=true
    var spreadDir = bulletArc/2.5
    repeat(bulletNum)
    {
        var inacArc = random(inaccuracyArc * 2) - inaccuracyArc;
        var aimMode = 0
        if image_xscale=1
        {
            var instProj = instance_create(x + lengthdir_x(24.1868, aimAngle+7.12502),y + 23 + lengthdir_y(24.1868, aimAngle+7.12502),o);
        }
        else
        {
            var instProj = instance_create(x - lengthdir_x(24.1868, aimAngle-7.12502),y + 23 - lengthdir_y(24.1868, aimAngle-7.12502),o);
            aimMode=180
        }
        instProj.speed = bulletSpd
        instProj.direction = aimAngle + inacArc + aimMode + spreadDir
        instProj.image_angle = aimAngle + inacArc + aimMode + spreadDir
        instProj.owner = id
        //if client=false
            //SendBullet(instProj)
        spreadDir -= bulletArc/bulletNum   
    }
    if bulletStringN<bulletString
    {
        rofcd = bulletStringCD
        bulletStringN++
    }
    else
    {
        shooting=false
        bulletStringN=0
        rofcd = rof
    }
}
else
    chargeUp++
