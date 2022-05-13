import React, { useState, useEffect } from 'react';

/// import react router dom
import { useNavigate, useLocation } from "react-router-dom";

/// combobox react for load data mesin
import AsyncSelect from 'react-select/async'
import Select from 'react-select'

/// import axios
import axios from '../../../utils/server';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";
import swal from 'sweetalert'

const loadkategori = [
    { value: 'Electrical', label: 'Electrical' },
    { value: 'Mechanical', label: "Mechanical" }
]

const EditKomponen = () => {

    const [idkomponen, setIdKomponen] = useState('')
    const [idMesin, setIdMesin] = useState('')
    const [nomesin, setNomesin] = useState('')
    const [ketmesin, setKetMesin] = useState('')
    const [nama, setNama] = useState('')
    const [keterangan, setKeterangan] = useState('')
    const [reminder, setReminder] = useState('1')
    const [jml_reminder, setJmlReminder] = useState('')
    const [kategori, setKategori] = useState('')
    const [isChecked, setIsChecked] = useState(true)
    const location = useLocation()
    useEffect(() => {
        /// set value from props
        setIdKomponen(location.state.data.idkomponen)
        setIdMesin(location.state.data.idmesin)
        setNomesin(location.state.data.nomesin)
        setKetMesin(location.state.data.keterangan)
        setNama(location.state.data.nama)
        setKeterangan(location.state.data.ketkomponen)
        setReminder(location.state.data.flag_reminder)
        setJmlReminder(location.state.data.jumlah_reminder)
        setKategori(location.state.data.kategori)
        if (reminder === '1') setIsChecked(true)
    }, [location])

    /// previous page handler
    const history = useNavigate()

    /// modal konfirmasi
    const KonfirmasiData = async (e) => {
        swal({
            title: `Yakin memperbarui ${nama}?`,
            text: "Pastikan data yang anda masukkan sudah sesuai!",
            icon: "warning",
            buttons: true,
            dangerMode: true,
            closeOnClickOutside: false,
            closeOnEsc: false,
        }).then((willDelete) => {
            if (willDelete) {
                SimpanKomponen(e)
            }
        });
    }

    /// getting data mesin from api for dropdown mesin
    const loadMesin = (e) => {
        return axios.get("mesin/0", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            const respon = response.data.data
            return respon
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }

    const SimpanKomponen = async (e) => {
        e.preventDefault();
        const datakomponen = {
            idmesin: idMesin,
            nama: nama,
            flag_reminder: reminder,
            keterangan: keterangan,
            jumlah_reminder: jml_reminder,
            kategori: kategori
        }
        await axios
            .put("komponen/"+idkomponen, datakomponen, {
                headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
            })
            .then((response) => {
                swal(`${response.data.message}`, {
                    icon: "success",
                });
                history("/datakomponen");
            })
            .catch((error) => {
                swal(`${error.response.data}`, {
                    icon: "error",
                });
            });
    }

    const checkReminder = () => {
        setIsChecked(!isChecked);
        isChecked === true ? setReminder('1') : setReminder('0')
    }

    const onChangeKategori = (value) => {
        setKategori(value ? value.value : "");
    }

    const onChangeMesin = (value) => {
        setIdMesin(value ? value.idmesin : "");
        setNomesin(value ? value.nomesin : "");
        setKetMesin(value ? value.keterangan : "");
    }

    return (
        <>
            {/* /// navigation bar */}
            <NavbarComponent />
            <div className="md:container lg:mx-auto  mt-3">
                {/* /// name page */}
                <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                    Tambah Komponen
                </h1>
                {/* <div className='block p-6 rounded-lg shadow-md bg-white max-w-md'> */}
                {/* /// form design */}
                <form className='w-full'>
                    {/* /// row 1 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// combo box mesin */}
                        <div className='w-full md:w-1/2 px-3 mb-6 md:mb-0'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Mesin</label>
                            <div className='relative'>
                                {/* <AsyncSelect className='block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight focus:outline-none focus:bg-white focus:border-gray-500' */}
                                <AsyncSelect
                                    inputValue={nomesin+' - '+ketmesin}
                                    cacheOptions
                                    defaultOptions
                                    getOptionLabel={e => e.nomesin + " - " + e.keterangan}
                                    getOptionValue={e => e.idmesin}
                                    loadOptions={loadMesin}
                                    placeholder="Pilih Mesin..."
                                    onChange={onChangeMesin}
                                />
                            </div>
                        </div>
                        {/* /// input nama mesin */}
                        <div className='w-full md:w-1/2'>
                            <div className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>
                                <label>Nama Komponen</label>
                                <input
                                    required
                                    type="text"
                                    className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                    placeholder='Nama Komponen'
                                    value={nama}
                                    onChange={(e) => setNama(e.target.value)} />
                            </div>
                        </div>
                    </div>
                    {/* /// row 2 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input keterangan */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Keterangan</label>
                            <input
                                required
                                type="text"
                                className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Keterangan'
                                value={keterangan}
                                onChange={(e) => setKeterangan(e.target.value)} />
                        </div>
                    </div>
                    {/* /// row 3 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input jumlah reminder */}
                        <div className='w-full md:w-1/2 px-3 mb-6 md:mb-0'>
                            {/* <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Jumlah Reminder</label> */}
                            <input className='form-check-input h-4 w-4 border border-gray-300 rounded-sm transition checked:border-blue-600 checked:bg-blue-600 focus:outline-none duration-200 mt-1 align-top bg-center bg-contain float-left mr-2 cursor-pointer'
                                type="checkbox"
                                id="checkbox"
                                checked={isChecked}
                                onChange={checkReminder} />
                            <label>Reminder</label>
                            <input
                                required
                                type="text"
                                disabled={isChecked === true ? false : true}
                                className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white focus:border-gray-500'
                                placeholder='Jumlah Remider'
                                value={jml_reminder}
                                onChange={(e) => setJmlReminder(e.target.value)} />
                            <p className='text-gray-600 text-xs italic mt-2'>(*) jumlah dalam hari</p>
                        </div>
                        {/* /// combo kategori */}
                        <div className='w-full md:w-1/2 px-3 mb-6 md:mb-0'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Kategori</label>
                            <div className='relative'>
                                <Select
                                    inputValue={kategori}
                                    options={loadkategori}
                                    getOptionValue={e => e.value}
                                    placeholder="Pilih Kategori..."
                                    onChange={onChangeKategori} />
                            </div>
                        </div>
                    </div>
                    {/* /// button simpan */}
                    <button type='button' onClick={(e)=>KonfirmasiData(e)} className='w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-600'>Simpan</button>
                </form>
                {/* </div> */}
            </div>
        </>
    );
}

export default EditKomponen;
