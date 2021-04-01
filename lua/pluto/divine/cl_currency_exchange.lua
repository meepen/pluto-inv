function pluto.inv.writeexchangestardust(forwhat, howmany)
	net.WriteString(forwhat)
	net.WriteUInt(howmany, 32)
end