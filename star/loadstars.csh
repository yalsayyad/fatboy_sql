#!/bin/csh

setenv FREETDSCONF /astro/net/pogo3/yusra/freetds-0.82/build/etc/freetds.conf
setenv  LD_LIBRARY_PATH /astro/net/pogo3/yusra/freetds-0.82/build/lib

foreach thepath (`ls /astro/net/pogo3/dC3b/pT2/newCatsOut/eqStripm60*_out.gz`)
    echo $thepath
    zcat $thepath > ./filetoload.dat

    echo /astro/net/pogo3/yusra/freetds-0.82/build/bin/freebcp '[LSST].dbo.starsStaging_m60m70' in './filetoload.dat' -t "," -b 100000 -S fatboy -U 'LSST-1' -P '<password>' -c
    /astro/net/pogo3/yusra/freetds-0.82/build/bin/freebcp '[LSST].dbo.starsStaging_m60m70' in  'filetoload.dat' -t ',' -b 100000 -S fatboy -U 'LSST-1' -P '<password>' -c

    echo rm ./filetoload.dat
    rm ./filetoload.dat
end
